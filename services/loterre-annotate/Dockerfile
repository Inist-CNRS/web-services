# syntax=docker/dockerfile:1.2

# ── Stage 1 : pull dictionnaires via DVC ────────────────────────────────────
FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install \
    git=1:2.30.2-1+deb11u5 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir \
    dvc[webdav]==3.39.0 \
    pathspec==0.12.1
COPY ./dictionary.dvc /dvc
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git config --global init.defaultBranch master && \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)" && \
    dvc pull -v

# ── Stage 2 : image principale ────────────────────────────────────────────────
FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

ENV LOTERRE_ANNOTATE_VERSION=0.9.1
ENV GIT_REPO=https://github.com/stephane54/loterre-annotate.git
ENV LOTERRE_RESOURCES_DIR=/app/public/resources
ENV LOTERRE_REGISTRY=/app/public/configs/registry.yaml

RUN apt-get update && \
    apt-get -y --no-install-recommends install git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Installe les modules Python loterre-annotate depuis GitHub
RUN pip install --upgrade pip && \
    pip install --no-cache-dir \
        "git+${GIT_REPO}@v${LOTERRE_ANNOTATE_VERSION}#egg=loterre-annotate"

# Récupère resources/ et configs/registry.yaml depuis le même repo GitHub
# (shallow clone pour limiter la taille)
RUN git clone --depth 1 --branch "v${LOTERRE_ANNOTATE_VERSION}" \
        "${GIT_REPO}" /tmp/loterre-src && \
    cp -r /tmp/loterre-src/resources /app/public/resources && \
    mkdir -p /app/public/configs && \
    cp /tmp/loterre-src/configs/registry.yaml /app/public/configs/registry.yaml && \
    rm -rf /tmp/loterre-src

# Modèles spaCy (sm — léger, suffisant pour les profils entity_strict / term_recall)
RUN pip install --no-cache-dir \
    "en_core_web_sm @ https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.7.1/en_core_web_sm-3.7.1-py3-none-any.whl" \
    "fr_core_news_sm @ https://github.com/explosion/spacy-models/releases/download/fr_core_news_sm-3.7.0/fr_core_news_sm-3.7.0-py3-none-any.whl"

RUN chown -R daemon:daemon /app/public/resources /app/public/configs

WORKDIR /app/public

COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json

# Dictionnaire depuis le stage DVC
COPY --chown=daemon:daemon --from=dvc-files /dvc/dictionary /app/public/dictionary/
