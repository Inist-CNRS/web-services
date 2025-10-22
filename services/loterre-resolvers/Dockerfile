# syntax=docker/dockerfile:1.2

FROM python:3.9-slim-bullseye AS dvcfiles
WORKDIR /dvc/data
WORKDIR /dvc
RUN apt-get update && apt-get -y install --no-install-recommends git=1:2.30.2-1+deb11u5 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir dvc[webdav]==3.42.0
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
COPY ./data/*.dvc /dvc/data/
COPY ./dvc.* /dvc/
RUN dvc pull -v
RUN mv databases/*.tgz . && \
    for tgz in *.tgz; do tar -xf "$tgz"; done

##################################################################
FROM cnrsinist/ezs-python-saxon-server:py3.9-no24-1.0.8

WORKDIR /app/public/v1
WORKDIR /app/public

# Install all node dependencies
RUN npm install --omit=dev \
    @ezs/core@4.1.1 \
    @ezs/analytics@2.3.6 \
    @ezs/basics@2.9.2 \
    @ezs/storage@3.2.6 \
    @ezs/xslt@1.3.32 && \
    npm cache clean --force

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon --from=dvcfiles /dvc/data/*.skos /app/data/
COPY --chown=daemon:daemon --from=dvcfiles /dvc/databases/ /app/data/databases/

COPY --chown=daemon:daemon ./config.json /app/
COPY --chown=daemon:daemon ./v1 /app/public/v1/
COPY --chown=daemon:daemon ./swagger.json /app/public/
# Clean base image example/test files
RUN rm /app/public/parse.*
