# Dockerfile
FROM python:3.9.18-slim-bullseye

ENV NODE_VERSION=24.7.0

RUN apt-get update && apt-get install -y --no-install-recommends curl=7.74.0-1.3+deb11u15 && apt-get clean && rm -rf /var/lib/apt/lists/*
# https://github.com/hadolint/hadolint/wiki/DL4006
# Set the SHELL option -o pipefail before RUN with a pipe in
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

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
