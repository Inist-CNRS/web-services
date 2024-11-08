#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import subprocess
import sys
import json

retrieve_id = json.loads(sys.stdin.read())["value"]

# Commande pour extraire l'archive
extract_cmd = f'cd /tmp/retrieve/ && tar -xzf {retrieve_id}'
subprocess.run(extract_cmd, shell=True)

# Commande pour lister les fichiers
list_cmd = 'ls -p /tmp/retrieve/datas | grep -v /'
bash = subprocess.run(list_cmd, shell=True, capture_output=True)

# Traiter le résultat
result = bash.stdout.decode("utf-8").strip().split("\n")

# Supprimer les fichiers engendrés par l'extraction
list_cmd = 'rm -r /tmp/retrieve/datas && rm /tmp/retrieve/log.csv'
bash = subprocess.run(list_cmd, shell=True, capture_output=True)

# On exécute le test
if set(result) == set(["271653795.zip","273522590.zip"]):
    sys.stdout.write(json.dumps({"value":"True"}))
else:
    sys.stdout.write(json.dumps({"value":"False"}))
