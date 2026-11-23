#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Service JSON-lines de détection de duplication d'image (copier-coller).
 
Lancement :  python imageDup-detect.py -p pdf     (défaut : les contenus sont des PDF)
             python imageDup-detect.py -p img     (les contenus sont des images)
Tous les documents d'un même lancement sont du même type (jamais de mélange).
 
Entrée  (une requête JSON par ligne sur stdin) :
    {"id": "test/test1.pdf", "value": {"data": [37, 80, ...]}, "PID<xxx>": "PID: 1234"}
Sortie  (une réponse JSON par ligne sur stdout) :
    {"value": "Ok", "summary": {...}}  ou  {"value": "Error: <message>", "summary": {}}
 
Pour chaque requête, 3 fichiers sont écrits dans /tmp/retrieve/<pid>/ ; leur nom
<nom> est dérivé de "id" (ex. "test/test1.pdf" donne "test__test1_pdf") :
    <nom>.json   la réponse (identique à celle envoyée sur stdout)
    <nom>.html   le rapport
    <nom>.png    l'image de sortie : images du PDF empilées, ou image seule,
                 avec les duplications dessinées
Le traitement (détection, rapport, noms de fichiers) est dans utils.py.
"""
 
import json
import sys
import traceback
 
from utils import parse_pid, process_document, save_json, to_bytes
 
data_type = "img" if "-p" in sys.argv and sys.argv[sys.argv.index("-p") + 1] == "img" else "pdf"
 
for line in sys.stdin:
    if not line.strip():
        continue
 
    pid, doc_id, summary = "unknown", None, {}
    try:
        data = json.loads(line)
        pid = parse_pid(data)
        doc_id = data.get("id")
        summary = process_document(to_bytes(data["value"]), pid, doc_id, data_type)
        result = "Ok"
    except Exception as exc:  # une requête invalide ne doit pas tuer le service
        sys.stderr.write(f"[imageDup-detect] error for pid={pid} id={doc_id}: {exc}\n")
        sys.stderr.write(traceback.format_exc())
        result = f"Error: {exc}"
 
    response = {"value": result, "summary": summary}
    save_json(response, pid, doc_id)
 
    sys.stdout.write(json.dumps(response) + "\n")