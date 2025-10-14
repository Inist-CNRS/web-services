# syntax=docker/dockerfile:1.2

####
# Get all web service's dvc files
####
FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.30.2-1+deb11u5 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir dvc[webdav]==3.39.0
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
FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

WORKDIR /app
# Install all python dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential=12.9 make=4.3-4.1 gcc=4:10.2.1-1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir --no-build-isolation \
    plac==1.4.3 \
    scipy==1.13.1 \
    numpy==1.26.3 \
    fasttext==0.9.2 && \
    apt-get remove -y --purge build-essential make gcc && \
    apt-get autoremove -y

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
# Copy dvc files
COPY --chown=daemon:daemon --from=dvc-files /dvc/models /app/public/models
