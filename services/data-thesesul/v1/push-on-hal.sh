#!/bin/bash

# Vérifier que le dossier est passé en argument
if [ -z "$1" ]; then
  echo "Veuillez spécifier un dossier."
  exit 1
fi

# Vérifier que le dossier existe
if [ ! -d "$1" ]; then
  echo "Le dossier spécifié n'existe pas."
  exit 1
fi

# Dossier d'entrée
directory=$1

# Ici modifier le login et mdp !
login="changer_le_login"
password="changer_mdp"
url="https://api-preprod.archives-ouvertes.fr/sword/hal/"

for file in "$directory"/*; do
  if [[ "$file" =~ \.xml$ ]]; then
    # Requête pour un fichier XML
    echo "Envoi du fichier XML : $file"
    curl -X POST -d @"$file" -v -u "$login:$password" "$url" \
      -H "Packaging:http://purl.org/net/sword-types/AOfr" \
      -H "Content-Type:text/xml"
  elif [[ "$file" =~ \.zip$ ]]; then
    # Requête pour un fichier ZIP
    echo "Envoi du fichier ZIP : $file"
    curl -v -u "$login:$password" "$url" \
      -H "Packaging:http://purl.org/net/sword-types/AOfr" \
      -X POST \
      -H "Content-Type:application/zip" \
      --data-binary @"$file"
  else
    # Ne devrait pas arriver mais ça ne coûte rien
    echo "Fichier ignoré (pas un XML ou un ZIP) : $file"
  fi
done

echo "Traitement terminé."
