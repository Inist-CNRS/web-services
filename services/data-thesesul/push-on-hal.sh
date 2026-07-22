#!/bin/bash

# Vérifier que le dossier est passé en argument et qu'il existe
if [ -z "$1" ]; then
  echo "Veuillez spécifier un dossier."
  exit 1
fi
if [ ! -d "$1" ]; then
  echo "Le dossier spécifié n'existe pas."
  exit 1
fi

# Lien vers le dossier datas résultant du WS
directory="$1"
LOG_FILE="erreurs_hal_$(date +%Y%m%d_%H%M%S).log"

# On créer un fichier qui n'écrit que les erreurs (contrairement à stdout)
echo "Date: $(date)" > "$LOG_FILE"
echo "Fichier,Code HTTP,Message" >> "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"

# Vérifier si le répertoire est vide
shopt -s nullglob
files=("$directory"/*)
if [ ${#files[@]} -eq 0 ]; then
  echo "Le dossier est vide."
  exit 1
fi

# Ici changer le login et le mot de passe.
login=""
password=""
url="https://api.archives-ouvertes.fr/sword/univ-lorraine/"

# le programme
for file in "$directory"/*; do
  if [[ "$file" =~ \.xml$ ]]; then
    echo "Envoi du fichier XML : $file"

    http_code=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d @"$file" -u "$login:$password" "$url" \
      -H "Packaging:http://purl.org/net/sword-types/AOfr" \
      -H "Content-Type:text/xml")

    echo "Code HTTP: $http_code"

    # suggestion d'emmy
    if [[ ! "$http_code" =~ ^2[0-9]{2}$ ]]; then
      echo "$(basename "$file"),$http_code,Erreur lors de l'envoi" >> "$LOG_FILE"
      echo "❌ ÉCHEC - Fichier : $file, Code HTTP : $http_code"
    else
      echo "✅ Succès - Fichier : $file, Code HTTP : $http_code"
    fi

  elif [[ "$file" =~ \.zip$ ]]; then
    xml_file="${file%.zip}.xml"
    echo "Envoi du fichier ZIP : $file (avec XML : $xml_file)"

    # même chose si les fichiers sont des ZIP (requête différente)
    http_code=$(curl -s -o /dev/null -w "%{http_code}" -u "$login:$password" "$url" \
      -H "Packaging:http://purl.org/net/sword-types/AOfr" \
      -X POST \
      -H "Content-Type:application/zip" \
      --data-binary @"$file" \
      -H "Content-Disposition: attachment; filename=$(basename "$xml_file")")

    echo "Code HTTP: $http_code"

    if [[ ! "$http_code" =~ ^2[0-9]{2}$ ]]; then
      echo "$(basename "$file"),$http_code,Erreur lors de l'envoi" >> "$LOG_FILE"
      echo "❌ ÉCHEC - Fichier : $file, Code HTTP : $http_code"
    else
      echo "✅ Succès - Fichier : $file, Code HTTP : $http_code"
    fi

  else
    echo "Fichier ignoré (pas un XML ou un ZIP) : $file"
  fi
done

echo ""
echo "Traitement terminé. Fichier de log : $LOG_FILE"
