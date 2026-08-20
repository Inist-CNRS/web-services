#!/usr/bin/env python3
"""
Équivalent de vectorize.py, mais appelle l'API d'embedding iLaaS au lieu
de charger le modèle localement.

Entrée/sortie strictement identiques à vectorize.py (même format NDJSON
sur stdin/stdout), pour rester interchangeable avec le reste du pipeline
(insert.py, orchestrateur RAG).
"""

import os
import sys
import json
import time
import requests
from concurrent.futures import ThreadPoolExecutor

# ==============================
# Configuration
# ==============================

API_KEY = os.getenv("ILAAS_API_KEY")
API_URL = "https://rag-api.ilaas.fr/v1/embeddings"
MODEL_NAME = "bge-m3"

MAX_RETRIES = 4
RETRY_DELAY = 2

# Nombre de documents traités par "lot" (pour le logging et le regroupement
# des appels en parallèle) — contrairement à vectorize.py, il ne s'agit pas
# d'un batch envoyé en un seul appel API, mais de N appels individuels
# exécutés en parallèle au sein du lot.
BATCH_SIZE = 32

# Nombre d'appels API simultanés au sein d'un même lot. L'API étant
# distante (I/O-bound), la parallélisation via threads est efficace ici,
# contrairement à un modèle local où le calcul est borné par le CPU/GPU.
MAX_WORKERS = 8


def log(msg):
    """Écrit un message de progression sur stderr."""
    sys.stderr.write(msg + "\n")
    sys.stderr.flush()


def extract_text_and_metadata(value):
    """
    `value` peut être :
    - une simple chaîne (cas d'une question à vectoriser, ex: orchestrateur RAG)
      -> pas de métadonnées associées.
    - un objet {"text": ..., "metadata": {...}} (cas d'un chunk de document
      à vectoriser pour l'ingestion, ex: script d'insertion Mongo)
      -> métadonnées à propager telles quelles.
    """
    if isinstance(value, dict):
        return value["text"], value.get("metadata")

    return value, None


# ==============================
# Appel à l'API d'embedding
# ==============================

def call_embedding_api(text: str):
    """
    Appelle l'API iLaaS pour un texte donné, avec retries en cas d'échec.
    Renvoie le vecteur d'embedding (list[float]), ou None si tous les
    essais ont échoué.
    """
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {API_KEY}",
    }
    payload = {
        "model": MODEL_NAME,
        "input": text,
    }

    for attempt in range(1, MAX_RETRIES + 1):
        try:
            response = requests.post(
                API_URL,
                headers=headers,
                json=payload,
                timeout=60,
            )
            response.raise_for_status()
            result = response.json()

            embedding = result.get("data", [{}])[0].get("embedding")
            if embedding is None:
                raise ValueError(f"Réponse API sans embedding : {result}")

            return embedding

        except Exception as e:
            log(
                f"[WARN] Échec de l'appel à l'API d'embedding "
                f"(tentative {attempt}/{MAX_RETRIES}) : {e}"
            )

            if attempt == MAX_RETRIES:
                return None

            time.sleep(RETRY_DELAY * attempt)


# ==============================
# Traitement d'un document
# ==============================

def process_item(item: dict):
    """
    Vectorise un document via l'API et construit sa sortie au même format
    que vectorize.py. Renvoie None si l'embedding a échoué (document ignoré,
    avec un warning déjà loggé par call_embedding_api).
    """
    text, metadata = extract_text_and_metadata(item["value"])

    embedding = call_embedding_api(text)
    if embedding is None:
        log(f"[WARN] Document {item['id']} ignoré (embedding échoué après {MAX_RETRIES} tentatives).")
        return None

    output_value = {
        "vector": embedding,
        "text": text,
    }

    # On ne rajoute "metadata" que si elle existe, pour ne pas polluer
    # la sortie du cas "question simple" (sans métadonnées).
    if metadata is not None:
        output_value["metadata"] = metadata

    return {
        "id": item["id"],
        "value": output_value,
    }


# ==============================
# Traitement par lot (parallélisé)
# ==============================

def process_batch(batch, batch_num=None, total_batches=None):
    if not batch:
        return

    _start = time.time()

    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        outputs = list(executor.map(process_item, batch))

    _duration = time.time() - _start

    if batch_num is not None and total_batches is not None:
        batch_label = f"Batch {batch_num}/{total_batches}"
    else:
        batch_label = f"Batch de {len(batch)} document(s)"

    log(f"[INFO] {batch_label} encodé en {_duration:.2f}s")

    for output in outputs:
        if output is None:
            continue
        sys.stdout.write(json.dumps(output, ensure_ascii=False))
        sys.stdout.write("\n")

    sys.stdout.flush()


# ==============================
# Main
# ==============================

if not API_KEY:
    log("[ERREUR] Variable d'environnement ILAAS_API_KEY manquante.")
    sys.exit(1)

log("[INFO] Lecture des données...")
all_data = []
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    all_data.append(json.loads(line))

total = len(all_data)
total_batches = (total + BATCH_SIZE - 1) // BATCH_SIZE
log(f"[INFO] {total} documents à vectoriser ({total_batches} batch(s))")

if total == 0:
    log("[WARN] Aucun document reçu.")
    sys.exit(0)

processed = 0

for batch_num, i in enumerate(range(0, total, BATCH_SIZE), start=1):
    batch = all_data[i:i + BATCH_SIZE]
    process_batch(batch, batch_num=batch_num, total_batches=total_batches)
    processed += len(batch)

log(f"[INFO] Vectorisation terminée : {processed}/{total} documents")