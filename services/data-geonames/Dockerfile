# syntax=docker/dockerfile:1.2
FROM ghcr.io/astral-sh/uv:0.12.12-python3.10-trixie-slim AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get install -y --no-install-recommends git=1:2.47.3-0+deb13u1 curl=8.14.1-2+deb13u7 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir dvc[webdav]==3.67.1
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
COPY ./v1/data.dvc /dvc
RUN dvc pull -v && \
    cat data/x* > data/allCountries_sorted.txt && \
    rm data/x*


FROM cnrsinist/ezs-python-pytorch-server:py3.10-no24-2.0.2
WORKDIR /app

# Install all python dependencies
RUN pip install --no-cache-dir \
    unidecode==1.4.0 \
    requests==2.32.5 \
    pandas==2.3.3 \
    rapidfuzz==3.13.0 \
    huggingface_hub==0.34.4

# ─── Téléchargement du modèle via curl ───────────────────────────────────────
ENV MODEL_DIR=/app/models/bert-finetuned-ner

RUN mkdir -p ${MODEL_DIR}

RUN BASE="https://huggingface.co/huggingface-course/bert-finetuned-ner/resolve/main" && \
    for FILE in \
        config.json \
        tokenizer_config.json \
        tokenizer.json \
        vocab.txt \
        special_tokens_map.json \
        pytorch_model.bin; \
    do \
        echo "Downloading ${FILE}..." && \
        curl -fL --retry 3 \
             -o "${MODEL_DIR}/${FILE}" \
             "${BASE}/${FILE}"; \
    done

# ─── Application ─────────────────────────────────────────────────────────────
WORKDIR /app/public

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
COPY --chown=daemon:daemon --from=dvc-files /dvc/data/ /app/public/v1/
