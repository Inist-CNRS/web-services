# syntax=docker/dockerfile:1.2

FROM ghcr.io/astral-sh/uv:0.12.12-python3.10-trixie-slim AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.47.3-0+deb13u1 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN uv pip install --system --no-cache "dvc[webdav]==3.67.1"
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

FROM cnrsinist/ezs-python-server:py3.10-no24-2.0.1

WORKDIR /app
# Install all python dependencies
RUN uv pip install --system --no-cache \
    scikit-learn==1.5.1 \
    requests==2.32.5

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json

COPY --chown=daemon:daemon --from=dvc-files /dvc/model.pkl /app/public/v1/model.pkl
