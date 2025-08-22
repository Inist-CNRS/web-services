# syntax=docker/dockerfile:1.2
FROM python:3.9-slim-bullseye AS build1
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
COPY ./v3/affiliation/models.dvc /dvc
RUN dvc pull -v

FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.12

USER root
# Install all python dependencies
RUN pip install fasttext-wheel==0.9.2 numpy==1.26.3

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public

COPY --chown=daemon:daemon --from=build1 /dvc/models /app/public/v3/affiliation/models

RUN chmod a+w /app/public/config.json && mv /app/public/config.json /app
