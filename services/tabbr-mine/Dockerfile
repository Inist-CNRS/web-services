# syntax=docker/dockerfile:1.2
FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get install -y --no-install-recommends git=1:2.30.2-1+deb11u5 curl=7.74.0-1.3+deb11u15 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir dvc[webdav]==3.39.0
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
COPY ./v1/model-splitted.dvc /dvc
RUN dvc pull -v && \
    cat model-splitted/* > model-splitted.tar.gz && \
    tar -xzvf model-splitted.tar.gz


FROM cnrsinist/ezs-python-pytorch-server:py3.9-no24-1.1.8

WORKDIR /app
# Install all python dependencies
RUN pip install --no-cache-dir \
    pandas==1.5.0 \
    accelerate==1.8.1 \
    requests==2.32.3 \
    beautifulsoup4==4.12.3 \
    lxml==5.2.2 \
    numpy==1.26.4


WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon --from=dvc-files /dvc/models /app/public/

COPY --chown=daemon:daemon ./config.json /app/config.json
COPY --chown=daemon:daemon . /app/public/
