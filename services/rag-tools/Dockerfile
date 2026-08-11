# syntax=docker/dockerfile:1.2

FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.14

WORKDIR /app

RUN pip install --no-cache-dir \
    sentence-transformers \
    huggingface_hub

# Télécharge le modèle dans l'image
RUN python -c "\
from sentence_transformers import SentenceTransformer; \
model = SentenceTransformer('BAAI/bge-m3'); \
model.save('/models/BAAI/bge-m3')"

WORKDIR /app/public

COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json