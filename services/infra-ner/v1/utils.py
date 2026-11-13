"""Fonctions utilitaires du web service de détection d'infrastructures.

Principe général :
1. On charge le référentiel (infrastructures.csv + aliases.csv) une seule fois.
2. On normalise le texte (minuscules, sans accents, sans ponctuation).
3. On cherche les alias exacts (Aho-Corasick), puis les variantes approximatives (rapidfuzz).
4. On résout les chevauchements (la correspondance la plus sûre et la plus longue gagne).
5. On renvoie une liste à plat : un élément par mention détectée.

Réglages orientés PRÉCISION : mieux vaut rater une mention que produire un faux positif.
"""

import csv
import re
import unicodedata
from dataclasses import dataclass
from pathlib import Path

import ahocorasick
from rapidfuzz import fuzz

# --------------------------------------------------------------------------
# Paramètres
# --------------------------------------------------------------------------

DATA_DIR = Path(__file__).parent / "data"
INFRASTRUCTURES_CSV = DATA_DIR / "infrastructures.csv"
ALIASES_CSV = DATA_DIR / "aliases.csv"

# Niveaux de confiance acceptés. Ajouter "moyenne" pour retrouver des acronymes
# très ambigus (ET, EST, ILL, FBI...), au prix de nombreux faux positifs.
CONFIDENCE_LEVELS = {"élevée"}

# Alias à ignorer (forme normalisée : minuscules, sans accents). "fair" désigne
# presque toujours les principes FAIR dans un texte scientifique.
IGNORED_ALIASES = {"fair"}

# Alias sensibles à la casse : dans le texte, "CERN" est accepté mais pas "cern".
# Concerne les alias très courts (6 lettres ou moins) et les acronymes d'un seul mot
# (comme "Apollon" ou "CONTINUUM", qui sont aussi des mots courants).
SHORT_ALIAS_MAX_LETTERS = 6

FUZZY_THRESHOLD = 92   # score minimal (0-100) pour une mention approximative
FUZZY_MIN_LENGTH = 14  # longueur minimale d'un alias pour être cherché en approximatif
ANCHOR_MIN_LENGTH = 4  # un mot-ancre est un mot d'au moins 4 lettres
ANCHOR_COUNT = 3       # nombre de mots-ancres (les plus rares du texte) utilisés par alias

CONTEXT_SIZE = 100     # nombre de caractères gardés avant/après chaque mention

# Champs de infrastructures.csv recopiés dans chaque résultat
INFRASTRUCTURE_FIELDS = ("acronyme", "nom_fr", "nom_en", "domaine_scientifique", "sources")


@dataclass
class Referential:
    """Tout ce qu'il faut pour détecter : fiches, alias, automate, alias approximatifs."""

    infrastructures: dict  # id -> fiche de l'infrastructure
    alias_lookup: dict     # alias normalisé -> liste de {infrastructure_id, alias_original, ...}
    automaton: object      # automate Aho-Corasick construit sur alias_lookup
    fuzzy_aliases: list    # alias normalisés éligibles à la recherche approximative


def load_csv(path):
    """Lit un CSV UTF-8 (avec ou sans BOM) séparé par des points-virgules."""
    with open(path, encoding="utf-8-sig", newline="") as csv_file:
        return list(csv.DictReader(csv_file, delimiter=";"))


def normalize(text):
    """Normalise un texte : minuscules, sans accents, ponctuation remplacée par un espace.

    Retourne (texte_normalisé, offsets) où offsets[i] est la position, dans le texte
    original, du caractère normalisé numéro i. Cela permet de retrouver le texte d'origine.
    """
    chars, offsets = [], []
    for position, char in enumerate(text):
        # NFKD sépare les lettres de leurs accents ("é" devient "e" + accent)
        for part in unicodedata.normalize("NFKD", char.casefold()):
            if unicodedata.combining(part):
                continue  # on ignore les accents
            if part.isalnum():
                chars.append(part)
                offsets.append(position)
            elif chars and chars[-1] != " ":
                chars.append(" ")  # tout séparateur devient un espace unique
                offsets.append(position)

    if chars and chars[-1] == " ":  # pas d'espace final
        chars.pop()
        offsets.pop()
    return "".join(chars), offsets


def letters(text):
    """Ne garde que les lettres et chiffres, casse conservée ("E-RIHS" -> "ERIHS")."""
    return "".join(char for char in text if char.isalnum())


def build_alias_patterns(alias):
    """Retourne les formes de recherche d'un alias : sa forme normalisée.

    Pour un acronyme court, on ajoute aussi la forme espacée ("ACTRIS" -> "a c t r i s").
    """
    normalized, _ = normalize(alias)
    if not normalized:
        return set()
    compact = normalized.replace(" ", "")
    if 2 <= len(compact) <= 10 and compact.isalpha():
        return {normalized, " ".join(compact)}
    return {normalized}


def load_referential():
    """Charge les CSV et construit les index de recherche (à appeler une seule fois)."""
    infrastructures = {row["id"]: row for row in load_csv(INFRASTRUCTURES_CSV)}

    # alias normalisé -> infos de chaque alias du référentiel ayant cette forme
    alias_lookup = {}
    for row in load_csv(ALIASES_CSV):
        alias = row.get("alias", "").strip()
        infrastructure_id = row.get("infrastructure_id", "").strip()
        confidence = row.get("niveau_confiance") or "élevée"
        if not alias or not infrastructure_id or confidence not in CONFIDENCE_LEVELS:
            continue
        normalized_alias = normalize(alias)[0]
        if normalized_alias in IGNORED_ALIASES:
            continue

        info = {
            "infrastructure_id": infrastructure_id,
            "alias_original": alias,
            # Alias court ou acronyme d'un seul mot : la casse du texte doit correspondre
            "case_sensitive": len(letters(alias)) <= SHORT_ALIAS_MAX_LETTERS
            or (row.get("type_alias") == "acronyme" and " " not in normalized_alias),
        }
        for pattern in build_alias_patterns(alias):
            infos = alias_lookup.setdefault(pattern, [])
            if info not in infos:
                infos.append(info)

    if not alias_lookup:
        raise ValueError("Aucun alias chargé : vérifier aliases.csv et CONFIDENCE_LEVELS")

    # Automate Aho-Corasick : trouve tous les alias d'un coup, en un seul passage
    automaton = ahocorasick.Automaton()
    for pattern in alias_lookup:
        automaton.add_word(pattern, pattern)
    automaton.make_automaton()

    # Alias éligibles au fuzzy : assez longs, de plusieurs mots, avec au moins un mot-ancre
    # (les acronymes espacés comme "a c t r i s" n'ont aucun mot-ancre : exclus d'office)
    fuzzy_aliases = [
        pattern
        for pattern in alias_lookup
        if len(pattern) >= FUZZY_MIN_LENGTH
        and " " in pattern
        and any(len(word) >= ANCHOR_MIN_LENGTH for word in pattern.split())
    ]
    return Referential(infrastructures, alias_lookup, automaton, fuzzy_aliases)


# --------------------------------------------------------------------------
# Recherche des alias dans le texte normalisé
# Une "correspondance" est un dict : {start, end, method, score, infos}
# avec start/end = positions dans le texte normalisé (end exclu).
# --------------------------------------------------------------------------

def original_span(offsets, start, end):
    """Convertit une position du texte normalisé en position dans le texte original."""
    return offsets[start], offsets[end - 1] + 1


def find_exact_matches(text, normalized, offsets, referential):
    """Trouve les alias présents tels quels (après normalisation), en mot entier."""
    matches = []
    for last_index, pattern in referential.automaton.iter(normalized):
        start, end = last_index - len(pattern) + 1, last_index + 1

        # On exige un mot entier : "ess" ne doit pas être trouvé dans "process"
        if (start > 0 and normalized[start - 1] != " ") or (
            end < len(normalized) and normalized[end] != " "
        ):
            continue

        # Pour un alias sensible à la casse, le texte doit être écrit comme l'alias
        written = letters(text[slice(*original_span(offsets, start, end))])
        infos = [
            info
            for info in referential.alias_lookup[pattern]
            if not info["case_sensitive"] or written == letters(info["alias_original"])
        ]
        if infos:
            matches.append({"start": start, "end": end, "method": "exact", "score": 100.0, "infos": infos})
    return matches


def find_fuzzy_matches(normalized, referential):
    """Trouve les variantes approximatives (fautes de frappe, mot en plus ou en moins).

    Comparer chaque alias à toutes les fenêtres du texte serait très lent. On utilise donc
    des "mots-ancres" : pour chaque alias, on ne teste que les fenêtres placées autour des
    occurrences exactes de ses mots les plus rares dans le texte.
    """
    # Position (début, fin) de chaque mot, et indices des occurrences de chaque mot
    words = [(m.start(), m.end()) for m in re.finditer(r"\S+", normalized)]
    occurrences = {}
    for index, (start, end) in enumerate(words):
        occurrences.setdefault(normalized[start:end], []).append(index)

    matches = []
    for alias in referential.fuzzy_aliases:
        alias_words = alias.split()
        size = len(alias_words)

        # Mots-ancres : mots de l'alias présents dans le texte, du plus rare au plus fréquent
        anchors = [w for w in dict.fromkeys(alias_words) if len(w) >= ANCHOR_MIN_LENGTH and w in occurrences]
        anchors.sort(key=lambda word: len(occurrences[word]))

        # Fenêtres candidates (premier mot, nombre de mots) autour de chaque ancre,
        # avec un décalage et une taille de +/- 1 mot pour tolérer un mot ajouté ou oublié
        candidates = set()
        for anchor in anchors[:ANCHOR_COUNT]:
            anchor_rank = alias_words.index(anchor)
            for index in occurrences[anchor]:
                for shift in (-1, 0, 1):
                    for window_size in (size - 1, size, size + 1):
                        candidates.add((index - anchor_rank + shift, window_size))

        for first, window_size in candidates:
            if window_size < 2 or first < 0 or first + window_size > len(words):
                continue
            start, end = words[first][0], words[first + window_size - 1][1]
            # score_cutoff : rapidfuzz renvoie 0 si le score est sous le seuil (calcul abrégé)
            score = fuzz.ratio(alias, normalized[start:end], score_cutoff=FUZZY_THRESHOLD)
            if score:
                matches.append(
                    {"start": start, "end": end, "method": "fuzzy", "score": score,
                     "infos": referential.alias_lookup[alias]}
                )
    return matches


def resolve_overlaps(matches, text_length):
    """Garde les meilleures correspondances sans chevauchement.

    Ordre de priorité : score le plus élevé (exact = 100), puis span le plus long.
    Ainsi "ACTRIS-France" l'emporte sur "ACTRIS", et une mention exacte sur une approximation.
    """
    taken = bytearray(text_length)  # taken[i] = 1 si le caractère i est déjà couvert
    kept = []
    for match in sorted(matches, key=lambda m: (-m["score"], m["start"] - m["end"], m["start"])):
        if taken.find(1, match["start"], match["end"]) == -1:
            taken[match["start"]:match["end"]] = b"\x01" * (match["end"] - match["start"])
            kept.append(match)
    return kept


# --------------------------------------------------------------------------
# Détection complète
# --------------------------------------------------------------------------

def make_result(text, offsets, match, record):
    """Construit un résultat : une mention, avec les champs utiles de son infrastructure.

    Les positions et le contexte sont ceux du texte ORIGINAL.
    """
    start, end = original_span(offsets, match["start"], match["end"])
    result = {"alias_detecte": text[start:end]}
    result.update({field: record.get(field, "") for field in INFRASTRUCTURE_FIELDS})
    result.update(
        {
            "score_similarite": round(match["score"], 1),
            "debut": start,
            "fin": end,
            "contexte": text[max(0, start - CONTEXT_SIZE): end + CONTEXT_SIZE],
        }
    )
    return result


def detect_infrastructures(text, referential):
    """Détecte les infrastructures citées dans `text`.

    Retourne une liste à plat, triée selon la position dans le texte : un élément par mention
    (si un alias désigne plusieurs infrastructures, on a un élément par infrastructure).
    """
    if not isinstance(text, str):
        return []
    normalized, offsets = normalize(text)
    if not normalized:
        return []

    matches = find_exact_matches(text, normalized, offsets, referential)
    matches += find_fuzzy_matches(normalized, referential)
    matches = resolve_overlaps(matches, len(normalized))

    results = []
    for match in matches:
        for info in match["infos"]:
            record = referential.infrastructures.get(info["infrastructure_id"], {})
            results.append(make_result(text, offsets, match, record))
    return sorted(results, key=lambda result: result["debut"])