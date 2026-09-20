#!/usr/bin/env bash
set -euo pipefail

MODEL_ID="Xenova/all-MiniLM-L6-v2"
REVISION="main"  # ou un hash de commit si tu veux figer la version
BASE_URL="https://huggingface.co/${MODEL_ID}/resolve/${REVISION}"
OUT_DIR="${1:-models/${MODEL_ID}}"

echo "Downloading ${MODEL_ID} into ${OUT_DIR}"

mkdir -p "${OUT_DIR}"

# Liste des fichiers nécessaires pour transformers.js
files=(
  "config.json"
  "tokenizer_config.json"
  "tokenizer.json"
  "special_tokens_map.json"
  "vocab.txt"
  "onnx/model_quantized.onnx"
)

for file in "${files[@]}"; do
  url="${BASE_URL}/${file}?download=true"
  dest="${OUT_DIR}/${file}"
  dest_dir="$(dirname "${dest}")"

  mkdir -p "${dest_dir}"

  echo "-> ${url}"
  curl -fL "${url}" -o "${dest}" || {
    echo "Échec du téléchargement de ${url}" >&2
    exit 1
  }
done

echo "Done."
