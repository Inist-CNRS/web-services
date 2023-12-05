# Dockerfile
FROM python:3.9-slim-bookworm

ENV NODE_VERSION=16.20.2

RUN apt update && apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.6/install.sh | bash

ENV NVM_DIR=/root/.nvm
WORKDIR /root
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
RUN chmod -R a+rwx /root

ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
