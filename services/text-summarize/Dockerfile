# syntax=docker/dockerfile:1.2

FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.30.2-1+deb11u4 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir dvc[webdav]==3.39.0
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
RUN dvc doctor
COPY ./v1/splitted-bart-large-cnn.dvc /dvc
COPY ./v1/mbart-large-50-finetuned-summarization-V2.dvc /dvc
RUN dvc pull -v
WORKDIR /dvc/splitted-bart-large-cnn
RUN cat x* > ../bart-large-cnn.tar
WORKDIR /dvc/mbart-large-50-finetuned-summarization-V2
RUN cat x* > ../mbart-large-50-finetuned-summarization-V2.tar

WORKDIR /dvc
RUN tar -xf bart-large-cnn.tar && \
    rm bart-large-cnn.tar && \
    rm /dvc/splitted-bart-large-cnn/x* && \
    tar -xf mbart-large-50-finetuned-summarization-V2.tar && \
    rm mbart-large-50-finetuned-summarization-V2.tar && \
    rm /dvc/mbart-large-50-finetuned-summarization-V2/x*


FROM cnrsinist/ezs-python-pytorch-server:py3.9-no16-1.1.6

ENV HF_HOME=/app/.cache/huggingface
ENV NUMBA_CACHE_DIR=/tmp/numba_cache

# Install all python dependencies
RUN pip install --no-cache-dir --no-build-isolation \
    --index-url https://download.pytorch.org/whl/cpu \
    --extra-index-url https://pypi.org/simple \
    transformers==4.41.2 \
    lxml==5.4.0

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json

COPY --chown=daemon:daemon --from=dvc-files /dvc/bart-large-cnn /app/public/v1/bart-large-cnn
COPY --chown=daemon:daemon --from=dvc-files /dvc/mbart-large-50-finetuned-summarization-V2 /app/public/v1/mbart-large-50-finetuned-summarization-V2
