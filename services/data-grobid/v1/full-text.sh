#!/usr/bin/env bash

# Télécharge les fichiers PDF dont les URLs sont fournies sur l'entrée standard
# (une ligne JSON par item, l'URL est dans le champ "value"), les traite avec
# GROBID en parallèle, puis émet un item JSON par item d'entrée.
# - PDF téléchargés : /tmp/upload
# - TEI générés     : /tmp/retrieve/teis
# La sortie standard doit rester du JSON valide (déconsommé par ezs),
# les erreurs sont donc loggées sur la sortie d'erreur standard.
# NB : le pool ezs maintient des processus en veille sur une entrée standard
# vide : le script quitte alors immédiatement, sans laisser de trace.

set -u

UPLOAD_DIR="/tmp/upload"
TEI_DIR="/tmp/retrieve/teis"
GROBID_API="${GROBID_API:-http://vp-istex-grobid.intra.inist.fr:45070/api}"
TREATMENT="${TREATMENT:-processFulltextDocument}"
PROCESSES="${PROCESSES:-4}"
GROBID_TIMEOUT="${GROBID_TIMEOUT:-600}"
export TEI_DIR GROBID_API TREATMENT GROBID_TIMEOUT

mkdir -p "$UPLOAD_DIR" "$TEI_DIR"

# Nettoyer les répertoires de travail des exécutions interrompues
# (ex. SIGKILL, docker stop) : un répertoire n'est en cours d'utilisation
# que si le PID qui l'a nommé est toujours vivant.
for dir in /tmp/grobid-*; do
    [[ -d "$dir" ]] || continue
    kill -0 "${dir#/tmp/grobid-}" 2>/dev/null || rm -rf "$dir"
done

workdir=""
index=0

# Créer le répertoire de travail, seulement s'il y a réellement des données
init() {
    workdir="/tmp/grobid-$$"
    export workdir
    mkdir -p "$workdir/jobs" "$workdir/out"
    trap 'rm -rf "$workdir"' EXIT
}

# Traiter une ligne d'entrée (à appeler après init)
process() {
    local line="$1"
    local url base dest name out curl_err

    index=$((index + 1))
    name=$(printf '%06d' "$index")
    out="$workdir/out/$name"

    # Rien à faire si la ligne est vide
    if [[ -z "$line" ]]; then
        return 0
    fi

    # Extraire l'URL depuis le champ "value" du JSON
    if [[ "$line" =~ \"value\":\"([^\"]*)\" ]]; then
        url="${BASH_REMATCH[1]}"
        # Les fins de ligne du fichier source arrivent encodées (\n, \r)
        url="${url//\\n/}"
        url="${url//\\r/}"
    else
        url=""
    fi

    # Ignorer les lignes sans URL (HTTP ou HTTPS)
    if [[ ! "$url" =~ ^https?:// ]]; then
        echo "[full-text] Ligne $index : URL absente ou invalide, ignorée" >&2
        printf '%s\n' "$line" > "$out"
        return 0
    fi

    # Nom du fichier : dernière partie du chemin de l'URL (sans la query string)
    base="${url##*/}"
    base="${base%%\?*}"
    if [[ -z "$base" || "$base" == "." ]]; then
        base="download-$index.pdf"
    fi

    dest="$UPLOAD_DIR/$base"

    # Éviter les collisions entre deux URLs ayant la même base de nom
    if [[ -e "$dest" ]]; then
        if [[ "$dest" == *.* ]]; then
            dest="${dest%.*}-$index.${dest##*.}"
        else
            dest="$dest-$index"
        fi
    fi

    # Télécharger le PDF (redirections suivies, 30 s de timeout de connexion,
    # 2 minutes de timeout globale)
    if ! curl_err=$(curl --fail --silent --show-error --location \
            --connect-timeout 30 --max-time 120 --output "$dest" "$url" 2>&1); then
        rm -f "$dest"
        echo "[full-text] Ligne $index : téléchargement échoué ($url) : $curl_err" >&2
        printf '%s\n' "$line" > "$out"
        return 0
    fi

    # Un fichier vide n'est pas un PDF exploitable
    if [[ ! -s "$dest" ]]; then
        rm -f "$dest"
        echo "[full-text] Ligne $index : fichier vide reçu ($url)" >&2
        printf '%s\n' "$line" > "$out"
        return 0
    fi

    # Préparer le travail GROBID (nom du résultat, PDF, ligne d'origine)
    {
        printf '%s\n' "$name"
        printf '%s\n' "$dest"
        printf '%s\n' "$line"
    } > "$workdir/jobs/$name"
}

# Entrée standard vide = slot de pool en veille (pas de données) :
# quitter sans laisser de trace
if ! IFS= read -r line; then
    exit 0
fi

init

process "$line"

while IFS= read -r line; do
    process "$line"
done

# Traitements GROBID en parallèle (un item par job, cf. xargs -P)
if compgen -G "$workdir/jobs/*" > /dev/null; then
    xargs -n1 -P"$PROCESSES" bash -c '
        job="$1"
        {
            read -r name
            read -r pdf
            IFS= read -r line
        } < "$job"
        base="${pdf##*/}"
        tei="$TEI_DIR/${base%.pdf}.tei.xml"
        if ! curl_err=$(curl --fail --silent --show-error \
                --connect-timeout 30 --max-time "$GROBID_TIMEOUT" \
                --form "input=@${pdf}" "${GROBID_API}/${TREATMENT}" --output "$tei" 2>&1) || [[ ! -s "$tei" ]]; then
            rm -f "$tei"
            echo "[full-text] Item $((10#$name)) : traitement GROBID échoué (${base}) : $curl_err" >&2
            printf "%s\n" "$line" > "$workdir/out/$name"
        else
            echo "[full-text] Item $((10#$name)) : GROBID OK (${base} -> ${tei})" >&2
            printf "%s,\"tei\":\"%s\"}\n" "${line%?}" "$tei" > "$workdir/out/$name"
        fi
    ' _ < <(printf '%s\n' "$workdir"/jobs/*)
fi

# Émettre les résultats dans l'ordre d'origine (padding => tri lexical correct)
for out in "$workdir"/out/*; do
    [[ -e "$out" ]] && cat "$out"
done

exit 0
