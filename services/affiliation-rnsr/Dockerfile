# syntax=docker/dockerfile:1.2
FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.30.2-1+deb11u5 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install "pathspec<0.12.0" dvc[webdav]==3.67.1

COPY ./v3/affiliation/models.dvc /dvc/models.dvc

RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    mkdir -p .dvc/cache/files/md5 && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)" && \
    dvc pull -j 1 -v
FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

WORKDIR /app
# Install all python dependencies
RUN pip install --no-cache-dir fasttext-wheel==0.9.2 numpy==1.26.3

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public
COPY --chown=daemon:daemon ./config.json /app/config.json
COPY --chown=daemon:daemon --from=dvc-files /dvc/models /app/public/v3/affiliation/models
