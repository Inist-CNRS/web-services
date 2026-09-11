# Dockerfile
FROM ghcr.io/astral-sh/uv:0.12.12-python3.10-trixie-slim

ENV NODE_VERSION=24.21.0
ENV NODE_ARCH=x64

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl=8.14.1-2+deb13u4 \
        xz-utils=5.8.1-1+deb13u1 && \
    curl -fsSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz \
        | tar -xJf - -C /usr/local --strip-components=1 && \
    apt-get purge -y --auto-remove curl xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Make sure that .npm folder is writable by the daemon user
WORKDIR /usr/sbin/.npm
RUN chmod -R a+rwx /usr/sbin/.npm
