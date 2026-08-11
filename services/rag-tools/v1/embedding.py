#!/usr/bin/env python3
import sys
import json
import logging
from sentence_transformers import SentenceTransformer

# Supprime le warning avant tout chargement
logging.getLogger("transformers.tokenization_utils_base").setLevel(logging.ERROR)

MODEL_PATH = "/models/BAAI/bge-m3"
BATCH_SIZE = 32

model = SentenceTransformer(MODEL_PATH)


def log(msg):
    """Écrit un message de progression sur stderr."""
    sys.stderr.write(msg + "\n")
    sys.stderr.flush()


def process_batch(batch):
    """Vectorise un batch de documents et écrit le résultat sur stdout."""
    if not batch:
        return

    texts = [item["value"] for item in batch]

    embeddings = model.encode(
        texts,
        normalize_embeddings=True,
        batch_size=BATCH_SIZE
    ).tolist()

    for item, text, embedding in zip(batch, texts, embeddings):
        output = {
            "id": item["id"],
            "value": {
                "vector": embedding,
                "text": text
            }
        }
        sys.stdout.write(json.dumps(output))
        sys.stdout.write("\n")

    sys.stdout.flush()


# Lecture complète de stdin pour connaître le total
log("[INFO] Lecture des données...")
all_data = []
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    all_data.append(json.loads(line))

total = len(all_data)
log(f"[INFO] {total} documents à vectoriser")

if total == 0:
    log("[WARN] Aucun document reçu.")
    sys.exit(0)

# Traitement par batch avec suivi de progression
processed = 0
last_logged_pct = -1

for i in range(0, total, BATCH_SIZE):
    batch = all_data[i:i + BATCH_SIZE]
    process_batch(batch)
    processed += len(batch)

    pct = (processed * 100) // total
    # Log tous les 10%
    milestone = (pct // 10) * 10
    if milestone > last_logged_pct:
        log(f"[INFO] Progression : {milestone}% ({processed}/{total})")
        last_logged_pct = milestone

log(f"[INFO] Vectorisation terminée : {processed}/{total} documents")