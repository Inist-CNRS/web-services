import sys
import json

from sentence_transformers import SentenceTransformer

# ==============================
# Configuration
# ==============================

MODEL_NAME = "BAAI/bge-m3"
BATCH_SIZE = 32

model = SentenceTransformer(MODEL_NAME)


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

    for item, embedding in zip(batch, embeddings):
        output = {"id": item["id"], "value": embedding}
        sys.stdout.write(json.dumps(output))
        sys.stdout.write("\n")


batch = []

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    data = json.loads(line)
    batch.append(data)

    if len(batch) >= BATCH_SIZE:
        process_batch(batch)
        batch = []

# Traiter les documents restants (dernier batch incomplet)
process_batch(batch)