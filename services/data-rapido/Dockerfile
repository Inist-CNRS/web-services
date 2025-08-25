# syntax=docker/dockerfile:1.2

FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt update && apt -y install git
RUN pip install dvc[webdav]==3.42.0
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
RUN dvc pull -v
RUN cat model_split/* > rapido-model.pt

FROM cnrsinist/ezs-python-pytorch-server:py3.9-no16-1.1.6

USER root
# Install all python dependencies
RUN pip install \
    unidecode==1.3.7 \
    spacy==3.6.1 \
    spacy_lefff==0.5.1 \
    en-core-web-sm@https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.6.0/en_core_web_sm-3.6.0.tar.gz \
    pandas==1.4.0 \
    lxml==4.7.1 \
    fr_core_news_sm@https://github.com/explosion/spacy-models/releases/download/fr_core_news_sm-3.6.0/fr_core_news_sm-3.6.0-py3-none-any.whl

# Install CURL to get spacy_lefff model and put it at the right place
RUN apt update && apt -y install curl tar
RUN curl -L -O https://github.com/sammous/spacy-lefff-model/releases/latest/download/model.tar.gz
RUN mkdir /usr/local/lib/python3.9/site-packages/spacy_lefff/data/tagger
RUN tar -xf model.tar.gz -C /usr/local/lib/python3.9/site-packages/spacy_lefff/data/tagger
WORKDIR /app/public

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json

COPY --chown=daemon:daemon --from=dvc-files /dvc/rapido-model.pt /app/public/v1/rapido-model.pt
