# syntax=docker/dockerfile:1.2

####
# Get all web services dvc files
####
FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.30.2-1+deb11u5 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir dvc[webdav]==3.39.0
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
# Build and install web services dependencies en files
####
FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

WORKDIR /app

# Install Cython requirement
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential=12.9 make=4.3-4.1 gcc=4:10.2.1-1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir Cython==0.29.37 && \
    # Install all python dependencies
    # Using build isolation to fix compile error
    # https://github.com/numpy/numpy/issues/24377#issuecomment-1671859253
    pip install --no-cache-dir --no-build-isolation \
    more-itertools==10.2.0 \
    numpy==1.26.3 \
    scipy==1.10.1 \
    fasttext==0.9.2 \
    faiss-cpu==1.7.2 && \
    # Clean-up
    apt-get remove -y --purge build-essential make gcc && \
    apt-get autoremove -y && \
    pip uninstall -y Cython

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
# Copy dvc files
COPY --chown=daemon:daemon --from=dvc-files /dvc/v1 /app/public/v1
