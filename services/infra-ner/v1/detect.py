#!/usr/bin/env python3
import json
import sys

from utils import detect_infrastructures, load_referential

# Le référentiel est chargé une seule fois, au démarrage du service
referential = load_referential()

for line in sys.stdin:
    if not line.strip():
        continue
    data = {}
    try:
        data = json.loads(line)
        data["value"] = detect_infrastructures(data["value"], referential)
    except Exception as error:
        message = f"{type(error).__name__}: {error}"
        print(message, file=sys.stderr, flush=True)
        data = data if isinstance(data, dict) else {}
        data["value"] = []
        data["error"] = message
    sys.stdout.write(json.dumps(data, ensure_ascii=False) + "\n")
    sys.stdout.flush()
