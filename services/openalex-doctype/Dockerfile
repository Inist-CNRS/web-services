# syntax=docker/dockerfile:1.2

FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.30.2-1+deb11u5 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir dvc[webdav]==3.66.1
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
RUN dvc doctor
COPY ./v1/model-splitted.dvc /dvc
RUN dvc pull -v && \
    cat model-splitted/* > model.pkl

FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

WORKDIR /app
# Install all python dependencies
RUN pip install --no-cache-dir \
    scikit-learn==1.5.1 \
    requests==2.32.5

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json

COPY --chown=daemon:daemon --from=dvc-files /dvc/model.pkl /app/public/v1/model.pkl
