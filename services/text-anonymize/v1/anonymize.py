#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import sys
import re
import time

from utils import anonymiser, precharger_modeles


data_type = sys.argv[sys.argv.index("-p") + 1] if "-p" in sys.argv else "en"
data_type = "en" if data_type != "fr" else data_type

# Charge les modèles spaCy une bonne fois pour toutes avant de traiter les
# lignes (sinon le premier appel à anonymiser() paierait le coût du
# chargement du modèle, ce qui ralentirait la toute première requête).
precharger_modeles(data_type)

for line in sys.stdin:
    data = json.loads(line)
    text = data["value"]
    res = anonymiser(text, langue=data_type)
    data["value"] = res
    sys.stdout.write(json.dumps(data))
    sys.stdout.write('\n')
    sys.stdout.flush()