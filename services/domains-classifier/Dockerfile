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
COPY ./models/models.dvc /dvc
RUN dvc pull -v

####
# Build and install web services dependencies files
####
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.11

USER root
# Install all python dependencies
RUN apt update && apt install -y build-essential make gcc && \
    pip install --no-build-isolation \
    plac==1.4.3 \
    scipy==1.13.1 \
    numpy==1.26.3 \
    fasttext==0.9.2 && \
    apt remove -y --purge build-essential make gcc && \
    apt autoremove -y

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json
# Copy dvc files
COPY --chown=daemon:daemon --from=dvc-files /dvc/models /app/public/models
