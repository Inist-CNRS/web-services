#!/usr/bin/env python3

import json
import sys

from utils import detect_infrastructures, load_referential

# Le référentiel est chargé une seule fois, au démarrage du service
referential = load_referential()

for line in sys.stdin:
    if not line.strip():
        continue
    data = json.loads(line)
    try:
        data["value"] = detect_infrastructures(data["value"], referential)
    except Exception as error:
        data["value"] = {"error": f"{type(error).__name__}: {error}"}
    sys.stdout.write(json.dumps(data, ensure_ascii=False) + "\n")
    sys.stdout.flush()
