# syntax=docker/dockerfile:1.2

####
# Get all web service's dvc files
####
FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.30.2-1+deb11u5 curl=7.74.0-1.3+deb11u15 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir dvc[webdav]==3.39.0
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
RUN curl -L https://huggingface.co/flair/ner-english/resolve/8280adae5dba43c6bea2e89986044fd50394f951/pytorch_model.bin?download=true -o /dvc/ner-english-model
COPY ./v1/v1.dvc /dvc
RUN dvc pull -v

####
# Build and install web services dependencies files
####
FROM cnrsinist/ezs-python-pytorch-server:py3.9-no24-1.1.8

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
# Copy dvc files
COPY --chown=daemon:daemon --from=dvc-files /dvc/v1 /app/public/v1
COPY --chown=daemon:daemon --from=dvc-files /dvc/ner-english-model /app/ner-english-model
