# syntax=docker/dockerfile:1.2

####
# Get all web services dvc files
####
FROM python:3.9-slim-bullseye as dvc-files
WORKDIR /dvc
RUN apt update && apt -y install git curl
RUN pip install dvc[webdav]==3.39.0
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
COPY ./v1/v1.dvc /dvc
RUN dvc pull -v
RUN cat /dvc/v1/en/HALen_matrixKDT.npy.* > /dvc/v1/en/HALen_matrixKDT.npy && \
    rm /dvc/v1/en/HALen_matrixKDT.npy.*

####
# Build and install web services dependcies en files
####
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.11

USER root

# Install Cython requirement
RUN apt update && \
    apt install -y build-essential make gcc && \
    pip install Cython==0.29.37 && \
# Install all python dependencies
# Using build isolation to fix compile error
# https://github.com/numpy/numpy/issues/24377#issuecomment-1671859253
    pip install --no-build-isolation \
        more-itertools==10.2.0 \
        numpy==1.26.3 \
        scipy==1.10.1 \
        fasttext==0.9.2 \
        faiss-cpu==1.7.2 && \
# Clean-up
    apt remove -y --purge build-essential make gcc && \
    apt autoremove -y && \
    pip uninstall -y Cython

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json
# Copy dvc files
COPY --chown=daemon:daemon --from=dvc-files /dvc/v1 /app/public/v1
