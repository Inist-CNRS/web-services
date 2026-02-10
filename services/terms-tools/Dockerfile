# syntax=docker/dockerfile:1.2

FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.30.2-1+deb11u5 && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir \
    dvc[webdav]==3.39.0 \
    pathspec==0.12.1

RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git config --global init.defaultBranch master  && \
    git init && \ 
    dvc init  && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
RUN dvc doctor
COPY ./dictionary.dvc /dvc
COPY ./data.dvc /dvc
RUN dvc pull -v

FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

ENV TERMS_TOOLS_VERSION=2.1
ENV GIT=https://github.com/stephane54/terms-tools.git
ENV DICO_PATH="/app/public/dictionary"

# Install required dependencies to build terms_tools
RUN apt-get update && \
    apt-get -y --no-install-recommends install -y unzip autoconf automake libtool pkg-config build-essential git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
RUN pip install --no-cache-dir git+$GIT@$TERMS_TOOLS_VERSION#egg=terms_tools

# download spacy models
RUN pip install  --no-cache-dir \
    en_core_web_trf@https://github.com/explosion/spacy-models/releases/download/en_core_web_trf-3.8.0/en_core_web_trf-3.8.0-py3-none-any.whl \
    fr_dep_news_trf@https://github.com/explosion/spacy-models/releases/download/fr_dep_news_trf-3.8.0/fr_dep_news_trf-3.8.0-py3-none-any.whl

# rendre possible installation des ressources stanza lors 1er execution (mkdir en user daemon)
RUN chmod 777 /usr/sbin/

WORKDIR /app/public

# If issues with bindings with version of node higher than 20, try adding this line
# RUN cd node_modules/node_postal && npm run install

# Declare files to copy in .dockerignore
#RUN chown -R daemon:daemon /usr/sbin/
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json

COPY --chown=daemon:daemon --from=dvc-files /dvc/dictionary /app/public/dictionary
COPY --chown=daemon:daemon --from=dvc-files /dvc/data  /app/public/data
