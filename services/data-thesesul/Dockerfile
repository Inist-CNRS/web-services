# syntax=docker/dockerfile:1.2

FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt update && apt -y install git
RUN pip install dvc[webdav]==3.55.2
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
RUN dvc doctor
COPY ./v1/xsl-files.tar.gz.dvc /dvc
RUN dvc pull -v


FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.11
USER root
RUN apt update && apt install xsltproc libxml2-utils -y
# Install all python dependencies
RUN pip install \
    requests==2.31.0

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon --from=dvc-files /dvc/xsl-files.tar.gz /app/public/v1/xsl-files.tar.gz

RUN mv ./config.json /app && chmod a+w /app/config.json && \
    tar -xzf /app/public/v1/xsl-files.tar.gz -C /app/public/v1/ && \
    rm /app/public/v1/xsl-files.tar.gz &&\
    mkdir /tmp/retrieve
