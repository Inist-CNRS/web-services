# syntax=docker/dockerfile:1.2

FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.14

WORKDIR /app

# Installe torch en version CPU uniquement : le wheel par défaut de pip
# embarque tout le support CUDA (bibliothèques NVIDIA), qui représente à
# lui seul plusieurs Go, totalement inutile sans GPU.
RUN pip install --no-cache-dir torch --extra-index-url https://download.pytorch.org/whl/cpu
# sentence-transformers réutilise le torch CPU déjà installé ci-dessus
# (huggingface_hub est déjà une dépendance transitive de
# sentence-transformers/transformers, pas besoin de l'installer à part).
RUN pip install --no-cache-dir sentence-transformers

# Télécharge le modèle, puis nettoie le cache de téléchargement HuggingFace
# dans la MÊME couche : le modèle existe sinon en double (cache + /models),
# soit environ 2,2 Go gaspillés inutilement.
RUN python -c "\
from sentence_transformers import SentenceTransformer; \
model = SentenceTransformer('BAAI/bge-m3'); \
model.save('/models/BAAI/bge-m3')" \
    && rm -rf /root/.cache/huggingface

WORKDIR /app/public

COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json