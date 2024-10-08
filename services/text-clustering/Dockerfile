# syntax=docker/dockerfile:1.2
FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt update && apt -y install git
RUN pip install dvc[webdav]==3.55.2
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
RUN dvc doctor
COPY ./v1/sinr_vector_scientific_abstract.pk.dvc /dvc
RUN dvc pull -v


FROM cnrsinist/ezs-python-pytorch-server:py3.9-no16-1.1.4

ENV HF_HOME=/app/.cache/huggingface
ENV NUMBA_CACHE_DIR=/tmp/numba_cache

USER root
# Install all python dependencies
# RUN apt install python3.9-dev \
#     build-essential \
#     libomp-dev

RUN apt update && apt -y install python3.9-dev build-essential libomp-dev

RUN pip install sinr==1.3.1 \
    scikit-learn==1.5.1 \
    prometheus-client==0.19.0 \
    hdbscan==0.8.38.post1

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv /app/public/config.json /app && chmod a+w /app/config.json
RUN mkdir /tmp/retrieve

COPY --chown=daemon:daemon --from=dvc-files /dvc/sinr_vector_scientific_abstract.pk /app/public/v1/sinr_vector_scientific_abstract.pk
