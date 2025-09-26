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

# lien vers le dossier datas résultant du service
directory="$1"

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
    # Si le fichier est un XML, pas de pdf donc requête différente
    echo "Envoi du fichier XML : $file"
    curl -X POST -d @"$file" -v -u "$login:$password" "$url" \
      -H "Packaging:http://purl.org/net/sword-types/AOfr" \
      -H "Content-Type:text/xml"
    if [ $? -ne 0 ]; then
      echo "Erreur lors de l'envoi du fichier XML : $file"
    fi
  elif [[ "$file" =~ \.zip$ ]]; then
    # Utile pour déclarer la notice lors du push
    xml_file="${file%.zip}.xml"
        
    # Envoie du ZIP
    curl -v -u "$login:$password" "$url" \
      -H "Packaging:http://purl.org/net/sword-types/AOfr" \
      -X POST \
      -H "Content-Type:application/zip" \
      --data-binary @"$file" \
      -H "Content-Disposition: attachment; filename=$(basename "$xml_file")"
    
    if [ $? -ne 0 ]; then
      echo "Erreur lors de l'envoi du fichier ZIP : $file avec le fichier XML associé : $xml_file"
    fi
  else
    # Si le fichier n'est ni un XML, ni un ZIP
    echo "Fichier ignoré (pas un XML ou un ZIP) : $file"
  fi
done

echo "Traitement terminé."
