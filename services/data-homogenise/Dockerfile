# syntax=docker/dockerfile:1.2
FROM ghcr.io/astral-sh/uv:0.12.12-python3.10-trixie-slim AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.47.3-0+deb13u1 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir dvc[webdav]==3.67.1
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


FROM cnrsinist/ezs-python-pytorch-server:py3.10-no24-2.0.2

ENV HF_HOME=/app/.cache/huggingface
ENV NUMBA_CACHE_DIR=/tmp/numba_cache

WORKDIR /app
# Install all python dependencies
RUN pip install --no-cache-dir --no-build-isolation \
    --index-url https://download.pytorch.org/whl/cpu \
    --extra-index-url https://pypi.org/simple \
    sentence-transformers==3.3.1 \
    huggingface_hub==0.23.2

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public
COPY --chown=daemon:daemon ./config.json /app/config.json

COPY --chown=daemon:daemon --from=dvc-files /dvc/all-MiniLM-L6-v2 /app/public/v1/all-MiniLM-L6-v2
