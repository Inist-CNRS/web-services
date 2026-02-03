#!/usr/bin/env bash

read -r FILE_PATH

if [ -z "$FILE_PATH" ]; then
    echo "No file path provided"
    exit 1
fi

echo "Fichier à traiter par Grobid: $FILE_PATH" 1>&2

XML=$(curl -H "Accept: application/xml" \
     --form input="@$FILE_PATH" \
     http://vp-istex-grobid.intra.inist.fr:45070/api/processFulltextDocument)

# Escape double quotes for JSON compatibility
XML=${XML//\"/\\\"}

echo "{\"id\": 1, \"value\": \"${XML}\"}"
