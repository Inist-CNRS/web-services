# Dockerfile
FROM ghcr.io/astral-sh/uv:0.12.12-python3.9-trixie-slim

ENV NODE_VERSION=24.21.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl=8.14.1-2+deb13u4 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | bash

ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && \
    nvm install ${NODE_VERSION} && \
    nvm use v${NODE_VERSION} && \
    nvm alias default v${NODE_VERSION} && \
    nvm cache clear

# Make sure that .npm folder is readable by the daemon user
WORKDIR /root/.npm
RUN chmod -R a+rwx /root && \
    chown -R 1:1 "/root/.npm"
WORKDIR /root

ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
