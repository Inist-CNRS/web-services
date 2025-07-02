# syntax=docker/dockerfile:1.2

FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt update && apt -y install git
RUN pip install dvc[webdav]==3.42.0
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
RUN dvc doctor
COPY ./v1/data.dvc /dvc
RUN dvc pull -v
RUN cat data/* > model-dataset.pt

FROM cnrsinist/ezs-python-pytorch-server:py3.9-no16-1.1.4

USER root
# Install all python dependencies
RUN pip install \
    pymupdf==1.26.1 \
    flair==0.15.1 \
    kaggle==1.7.4.5 \
    unidecode==1.4.0 \
    transformers==4.52.4

# Install CURL to get spacy_lefff model and put it at the right place
RUN apt update && apt -y install curl tar
WORKDIR /app/public

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json
RUN mkdir /usr/sbin/.config/
RUN mkdir /usr/sbin/.config/kaggle/

COPY --chown=daemon:daemon --from=dvc-files /dvc/model-dataset.pt /app/public/v1/model-dataset.pt
