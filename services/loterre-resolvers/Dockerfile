# TODO: add a DVC stage to get files to /app/data
FROM python:3.9-slim-bullseye AS dvcfiles
WORKDIR /dvc
RUN apt update && apt -y install git curl
RUN pip install dvc[webdav]==3.42.0
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
COPY ./data/*.dvc /dvc
RUN dvc pull -v


FROM cnrsinist/ezs-python-saxon-server:py3.9-no16-1.0.5 AS build

USER root

# Install all node dependencies
RUN npm install \
    @ezs/storage@3.2.3 \
    @ezs/xslt@1.3.31

# Declare files to copy in .dockerignore
WORKDIR /app/data
COPY --chown=daemon:daemon --from=dvcfiles /dvc/*.skos /app/data/
RUN chmod a+rwx /app/data

WORKDIR /app/public/v1
COPY --chown=daemon:daemon ./v1 /app/public/v1
COPY --chown=daemon:daemon ./swagger.json /app/public/
COPY --chown=daemon:daemon ./config.json /app

# Clean base image example/test files
WORKDIR /app/public
RUN rm /app/public/parse.*
