# syntax=docker/dockerfile:1.2
FROM python:3.9-slim-bullseye as dvc-files
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
RUN dvc doctor
COPY ./v1/all-MiniLM-L6-v2.dvc /dvc
RUN dvc pull -v


FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.10

USER root
# Install all python dependencies
RUN pip install \
    sentence-transformers==2.2.2 \
    umap-learn==0.5.5 \
    scikit-learn==1.4.1.post1 \
    prometheus-client==0.19.0

# Install all node dependencies
RUN npm install \
    "@ezs/analytics@2.2.2" \
    "@ezs/basics@2.6.0" \
    "@ezs/core@3.6.0" \
    "@ezs/spawn@1.4.5"

ENV NUMBA_CACHE_DIR=/tmp/numba_cache
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json

COPY --chown=daemon:daemon --from=dvc-files /dvc/all-MiniLM-L6-v2 /app/public/v1/all-MiniLM-L6-v2
