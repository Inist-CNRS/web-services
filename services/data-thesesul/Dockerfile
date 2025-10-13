# syntax=docker/dockerfile:1.2

FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.30.2-1+deb11u5 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir dvc[webdav]==3.55.2
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


FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends xsltproc=1.1.34-4+deb11u2 libxml2-utils=2.9.10+dfsg-6.7+deb11u8 && apt-get clean && rm -rf /var/lib/apt/lists/*
# Install all python dependencies
RUN pip install --no-cache-dir \
    requests==2.31.0

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
COPY --chown=daemon:daemon --from=dvc-files /dvc/xsl-files.tar.gz /app/public/v1/xsl-files.tar.gz

RUN tar -xzf /app/public/v1/xsl-files.tar.gz -C /app/public/v1/ && \
    rm /app/public/v1/xsl-files.tar.gz
