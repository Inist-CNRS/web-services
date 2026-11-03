# syntax=docker/dockerfile:1.2

####
# Get all web service's dvc files
####
FROM ghcr.io/astral-sh/uv:0.12.12-python3.10-trixie-slim AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.47.3-0+deb13u1 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir dvc[webdav]==3.67.1
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
COPY ./models/models.dvc /dvc
RUN dvc pull -vv

####
# Build and install web services dependencies files
####
FROM cnrsinist/ezs-python-server:py3.10-no24-2.0.5

WORKDIR /app
# Install all python dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential=12.12 make=4.4.1-2 gcc=4:14.2.0-1 && \
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
