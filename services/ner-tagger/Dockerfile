# syntax=docker/dockerfile:1.2

####
# Get all web service's dvc files
####
FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt update && apt -y install git curl
RUN pip install dvc[webdav]==3.39.0
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
FROM cnrsinist/ezs-python-pytorch-server:py3.9-no16-1.1.4

USER root

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json
# Copy dvc files
COPY --chown=daemon:daemon --from=dvc-files /dvc/v1 /app/public/v1
COPY --chown=daemon:daemon --from=dvc-files /dvc/ner-english-model /app/ner-english-model
