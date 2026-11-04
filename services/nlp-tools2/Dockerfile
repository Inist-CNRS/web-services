# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.10-no24-2.0.5

ENV EN_CORE_WEB_SM_VERSION=https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.6.0/en_core_web_sm-3.6.0-py3-none-any.whl

# pycld3 has no wheel for Python 3.10: build it from source with protoc and a
# C++ compiler, then remove the build dependencies from the image.
RUN apt-get update && apt-get install -y --no-install-recommends \
    g++=4:14.2.0-1 \
    libc6-dev=2.41-12+deb13u4 \
    libprotobuf-dev=3.21.12-11+deb13u1 \
    libprotobuf32t64=3.21.12-11+deb13u1 \
    make=4.4.1-2 \
    pkg-config=1.8.1-4 \
    protobuf-compiler=3.21.12-11+deb13u1 \
    && uv pip install --system --no-cache \
    numpy==1.26.3 \
    pycld3==0.22 \
    spacy==3.6.1 \
    en-core-web-sm@${EN_CORE_WEB_SM_VERSION} \
    && apt-get purge -y \
    g++ \
    libc6-dev \
    libprotobuf-dev \
    make \
    pkg-config \
    protobuf-compiler \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/public

COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
