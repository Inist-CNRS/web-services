# syntax=docker/dockerfile:1.2
FROM python:3.9-slim-bullseye as build1
WORKDIR /dvc
RUN apt update && apt -y install git
RUN pip install dvc[webdav]==3.39.0
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
COPY ./v1/diseases/models.dvc /dvc
RUN dvc pull -v

FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.9

USER root
RUN pip install torch==2.1.0+cpu --index-url https://download.pytorch.org/whl/cpu
RUN pip install transformers==4.30.2 certifi==2024.2.2

USER daemon
WORKDIR /app/public
# Declare files to copy in .dockerignore
# A modifier : (utiliser le .dockerignore)
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json

COPY --chown=daemon:daemon --from=build1 /dvc/models /app/public/v1/diseases/models
