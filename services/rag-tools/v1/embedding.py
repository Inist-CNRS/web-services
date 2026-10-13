#!/usr/bin/env python3
import os

# ──────────────────────────────────────────────────────────────────────────
# Optimisations CPU — à faire AVANT tout import de torch/sentence_transformers,
# car OMP_NUM_THREADS/MKL_NUM_THREADS ne sont lus qu'à l'initialisation des
# bibliothèques de calcul (OpenMP/MKL), pas modifiables après coup.
# ──────────────────────────────────────────────────────────────────────────
_NUM_THREADS = str(os.cpu_count() or 1)
os.environ.setdefault("OMP_NUM_THREADS", _NUM_THREADS)
os.environ.setdefault("MKL_NUM_THREADS", _NUM_THREADS)
# Évite les ralentissements liés aux nombres flottants dénormalisés
# (fréquents en sortie de couches d'activation), gain "gratuit" sur CPU.
os.environ.setdefault("KMP_AFFINITY", "granularity=fine,compact,1,0")

import sys
import json
import time
import logging
import torch
from sentence_transformers import SentenceTransformer

# Supprime le warning avant tout chargement
logging.getLogger("transformers.tokenization_utils_base").setLevel(logging.ERROR)

MODEL_PATH = "/models/BAAI/bge-m3"

# Batch plus large que la valeur par défaut initiale : sur CPU, un batch
# trop petit sous-exploite la vectorisation SIMD/BLAS ; un batch plus
# grand amortit mieux les coûts fixes. À ajuster selon la RAM disponible
# (chaque doc supplémentaire dans le batch consomme de la mémoire).
BATCH_SIZE = 64

# bge-m3 supporte nativement jusqu'à 8192 tokens (usage "contexte long"),
# mais nos chunks font ~400 mots (~500-600 tokens). Sans plafond explicite,
# le modèle peut padder/traiter des séquences bien plus longues que
# nécessaire, ce qui coûte cher en calcul (l'attention croît de façon
# quadratique avec la longueur de séquence).
MAX_SEQ_LENGTH = 512


def log(msg):
    """Écrit un message de progression sur stderr."""
    sys.stderr.write(msg + "\n")
    sys.stderr.flush()


# ──────────────────────────────────────────────────────────────────────────
# Configuration explicite de PyTorch pour le calcul CPU pur.
#
# - set_num_threads : parallélisme "intra-op" (une seule opération, ex:
#   une multiplication de matrices, répartie sur plusieurs cœurs). C'est
#   le levier principal pour accélérer un encode() séquentiel.
# - set_num_interop_threads : parallélisme "inter-op" (plusieurs opérations
#   indépendantes en parallèle). Inutile ici puisqu'on fait des appels
#   encode() séquentiels un par un ; le laisser à 1 réduit l'overhead de
#   coordination entre threads plutôt que de l'aider. Doit être fixé AVANT
#   toute opération torch, sous peine d'erreur si déjà initialisé.
# - set_flush_denormal : évite le ralentissement CPU causé par les nombres
#   flottants "dénormalisés" (très proches de zéro), qui peuvent être
#   traités beaucoup plus lentement par le FPU sur certains processeurs.
# ──────────────────────────────────────────────────────────────────────────
_num_threads = os.cpu_count() or 1
torch.set_num_threads(_num_threads)
try:
    torch.set_num_interop_threads(1)
except RuntimeError:
    # Déjà initialisé ailleurs (ex: import précédent) : sans impact bloquant,
    # on continue avec la valeur par défaut.
    pass
torch.set_flush_denormal(True)

log("[INFO] Chargement du modèle...")
_load_start = time.time()

model = SentenceTransformer(MODEL_PATH, device="cpu")
model.max_seq_length = MAX_SEQ_LENGTH

_load_duration = time.time() - _load_start
log(f"[INFO] Modèle chargé en {_load_duration:.1f}s sur device : {model.device}")
log(f"[INFO] max_seq_length fixé à {MAX_SEQ_LENGTH} tokens")
log(f"[INFO] Threads CPU (intra-op) : {_num_threads} | BATCH_SIZE : {BATCH_SIZE}")


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


def process_batch(batch, batch_num=None, total_batches=None):
    """Vectorise un batch de documents et écrit le résultat sur stdout."""
    if not batch:
        return

    texts = []
    metadatas = []

    for item in batch:
        text, metadata = extract_text_and_metadata(item["value"])
        texts.append(text)
        metadatas.append(metadata)

    _encode_start = time.time()
    with torch.no_grad():
        embeddings = model.encode(
            texts,
            normalize_embeddings=True,
            batch_size=BATCH_SIZE,
            convert_to_numpy=True,
        ).tolist()
    _encode_duration = time.time() - _encode_start

    if batch_num is not None and total_batches is not None:
        batch_label = f"Batch {batch_num}/{total_batches}"
    else:
        batch_label = f"Batch de {len(batch)} document(s)"

    log(f"[INFO] {batch_label} encodé en {_encode_duration:.2f}s")

    for item, text, metadata, embedding in zip(batch, texts, metadatas, embeddings):
        output_value = {
            "vector": embedding,
            "text": text
        }

        # On ne rajoute "metadata" que si elle existe, pour ne pas polluer
        # la sortie du cas "question simple" (sans métadonnées).
        if metadata is not None:
            output_value["metadata"] = metadata

        output = {
            "id": item["id"],
            "value": output_value
        }
        sys.stdout.write(json.dumps(output, ensure_ascii=False))
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
total_batches = (total + BATCH_SIZE - 1) // BATCH_SIZE
log(f"[INFO] {total} documents à vectoriser ({total_batches} batch(s))")

if total == 0:
    log("[WARN] Aucun document reçu.")
    sys.exit(0)

# Traitement par batch
processed = 0

for batch_num, i in enumerate(range(0, total, BATCH_SIZE), start=1):
    batch = all_data[i:i + BATCH_SIZE]
    process_batch(batch, batch_num=batch_num, total_batches=total_batches)
    processed += len(batch)

log(f"[INFO] Vectorisation terminée : {processed}/{total} documents")