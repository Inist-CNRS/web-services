# syntax=docker/dockerfile:1.2
FROM python:3.9-slim-bullseye as build1
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

FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.10

USER root
# Install all python dependencies
RUN pip install fasttext-wheel==0.9.2

WORKDIR /app/public
# Declare files to copy in .dockerignore
# A modifier : (utiliser le .dockerignore)
COPY --chown=daemon:daemon ./v2/affiliation /app/public/v2/affiliation
COPY --chown=daemon:daemon ./v3/affiliation /app/public/v3/affiliation

COPY --chown=daemon:daemon --from=build1 /dvc/models /app/public/v3/affiliation/models
