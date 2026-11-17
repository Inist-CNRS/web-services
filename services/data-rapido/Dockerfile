# syntax=docker/dockerfile:1.2

FROM ghcr.io/astral-sh/uv:0.12.12-python3.10-trixie-slim AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.47.3-0+deb13u1 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN uv pip install --system --no-cache dvc[webdav]==3.67.1 "pathspec==0.10.3"
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
RUN dvc doctor
COPY ./v1/model_split.dvc /dvc
RUN dvc pull -v && \
    cat model_split/* > rapido-model.pt

FROM cnrsinist/ezs-python-pytorch-server:py3.10-no24-2.0.2

WORKDIR /app
# Install all python dependencies
RUN uv pip install --system --no-cache \
    unidecode==1.3.7 \
    spacy==3.6.1 \
    spacy_lefff==0.5.1 \
    en-core-web-sm@https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.6.0/en_core_web_sm-3.6.0.tar.gz \
    pandas==1.4.0 \
    lxml==4.7.1 \
    fr_core_news_sm@https://github.com/explosion/spacy-models/releases/download/fr_core_news_sm-3.6.0/fr_core_news_sm-3.6.0-py3-none-any.whl

# Install CURL to get spacy_lefff model and put it at the right place
RUN apt-get update && apt-get -y --no-install-recommends install curl=8.14.1-2+deb13u7 tar=1.35+dfsg-3.1 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl -L -O https://github.com/sammous/spacy-lefff-model/releases/latest/download/model.tar.gz
RUN LEFFF_DATA_DIR="$(python -c 'import os, spacy_lefff; print(os.path.join(os.path.dirname(spacy_lefff.__file__), "data", "tagger"))')" && \
    mkdir -p "$LEFFF_DATA_DIR" && \
    tar -xf model.tar.gz -C "$LEFFF_DATA_DIR" && \
    rm model.tar.gz
WORKDIR /app/public

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json

COPY --chown=daemon:daemon --from=dvc-files /dvc/rapido-model.pt /app/public/v1/rapido-model.pt
