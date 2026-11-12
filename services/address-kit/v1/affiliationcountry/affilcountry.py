#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import os
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed

import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
from pathlib import Path

EMPTY = {"city": None, "country": None}

# ----------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------
API_KEY = os.getenv("ILAAS_API_KEY")

def log(msg):
    """Les logs vont sur stderr pour ne pas polluer stdout."""
    print(msg, file=sys.stderr, flush=True)
if not API_KEY:
    log("ILAAS_API_KEY is not set")
    sys.exit(1)

BASE_URL = "https://llm.ilaas.fr/v1"

MODEL_NAME = os.getenv("MODEL_NAME", "gemma-4-31b") # à tester qwen-3.8-27b
MAX_WORKERS = int(os.getenv("MAX_WORKERS", "12"))   # Requêtes en parallèle
BATCH_SIZE = int(os.getenv("BATCH_SIZE", "10"))     # Affiliations par requête

# ----------------------------------------------------------------------
# Prompt
# ----------------------------------------------------------------------
PROMPT_PATH = Path(__file__).parent / "prompt.txt"
SYSTEM_PROMPT = PROMPT_PATH.read_text(encoding="utf-8")

# ----------------------------------------------------------------------
# Session HTTP avec retry (POST inclus) et backoff exponentiel
# ----------------------------------------------------------------------
session = requests.Session()
session.headers.update({
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json",
})

retry = Retry(
    total=3,
    connect=3,          # timeout de connexion / connexion refusée
    read=3,             # timeout de lecture (le modèle met trop de temps à répondre)
    status=3,
    status_forcelist=[429, 502, 503, 504],  # Too Many Requests, Bad Gateway, Service Unavailable, Gateway Timeout
    other=0,
    redirect=0,
    backoff_factor=2,
    allowed_methods=["POST"],
    raise_on_status=False,
    respect_retry_after_header=True,   # attend le délai demandé par le serveur
)
adapter = HTTPAdapter(max_retries=retry, pool_connections=MAX_WORKERS, pool_maxsize=MAX_WORKERS)
session.mount("https://", adapter)
session.mount("http://", adapter)


# ----------------------------------------------------------------------
# Utilitaires
# ----------------------------------------------------------------------
def clean_value(v):
    """Transforme les 'null' / 'none' / chaînes vides renvoyés par le modèle en None."""
    if v is None:
        return None
    v = str(v).strip()
    return None if v.lower() in ("", "null", "none", "n/a") else v


# ----------------------------------------------------------------------
# Extraction d'un lot
# ----------------------------------------------------------------------
json_schema = {
    "type": "array",
    "items": {
        "type": "object",
        "properties": {
            "id": {"type": "integer"},
            "country": {"type": ["string", "null"]},
            "city": {"type": ["string", "null"]},
        },
        "required": ["id", "country", "city"],
        "additionalProperties": False,
    },
}
def extract_batch(batch):
    """batch : liste d'affiliations -> dict {affiliation: résultat}"""
    user = "\n".join(f"{i}: {a.replace(chr(10), ' ')}" for i, a in enumerate(batch))
    payload = {
    "model": MODEL_NAME,
    "messages": [
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": user},
    ],
    "stream": False,
    "max_completion_tokens": 60 * len(batch) + 100,
    "response_format": {
        "type": "json_schema",
        "json_schema": {
            "name": "affiliation_locations",
            "strict": True,
            "schema": json_schema,
        },
    },
}
    try:
        response = session.post(f"{BASE_URL}/chat/completions", json=payload, timeout=120)
        if not response.ok:
            raise RuntimeError(f"HTTP {response.status_code} : {response.text[:200]}")

        content = response.json()["choices"][0]["message"].get("content") or ""
        by_id = {d["id"]: d for d in json.loads(content)}
        out = {}
        for i, aff in enumerate(batch):
            d = by_id[i]  # KeyError si le modèle a oublié une ligne -> lot redécoupé
            out[aff] = {
                "city": clean_value(d.get("city")),
                "country": clean_value(d.get("country")),
            }
        return out

    except Exception as e:
        if len(batch) == 1:
            log(f"Échec pour {batch[0][:50]!r} : {type(e).__name__}: {e}")
            return {batch[0]: dict(EMPTY)}
        # Lot en échec : on le coupe en deux et on recommence
        mid = len(batch) // 2
        return {**extract_batch(batch[:mid]), **extract_batch(batch[mid:])}


# ----------------------------------------------------------------------
# Toutes les affiliations, en parallèle
# ----------------------------------------------------------------------
def extract_locations(affiliations):
    """
    affiliations : liste d'affiliations (str). Les doublons sont ignorés : une seule
    requête par affiliation identique.
    Retourne un dict {affiliation: {"city": ..., "country": ...}}.
    """
    unique = list(dict.fromkeys(affiliations))
    batches = [unique[i:i + BATCH_SIZE] for i in range(0, len(unique), BATCH_SIZE)]

    locations = {}
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        futures = [executor.submit(extract_batch, b) for b in batches]
        for done, future in enumerate(as_completed(futures), start=1):
            locations.update(future.result())
            log(f"[{done}/{len(batches)}] lots traités ({len(locations)}/{len(unique)} affiliations)")
    return locations


# ----------------------------------------------------------------------
# stdin / stdout
# ----------------------------------------------------------------------
def main():
    affiliations = []
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        data = json.loads(line)
        affiliations.append((data.get("id"), data.get("value")))

    locations = extract_locations([aff for _, aff in affiliations])

    for id, aff in affiliations:
        loc = locations.get(aff, EMPTY)
        result = {
            "city": loc.get("city") or "n/a",
            "country": loc.get("country") or "n/a",
        }
        sys.stdout.write(json.dumps({"id": id, "value": result}))
        sys.stdout.write("\n")

if __name__ == "__main__":
    main()
