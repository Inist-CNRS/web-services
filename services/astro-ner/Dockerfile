FROM python:3.9-slim-bullseye AS dvcfiles
WORKDIR /dvc
RUN apt update && apt install -y --no-install-recommends git curl && rm -rf /var/lib/apt/lists/*
RUN pip install dvc[webdav]==3.42.0
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
COPY ./v1/model.dvc /dvc
RUN dvc pull -v
RUN cat model/* > model.pt

FROM cnrsinist/ezs-python-pytorch-server:py3.9-no16-1.1.6

WORKDIR /app

RUN pip install Unidecode==1.4.0
RUN npm install @ezs/storage@3.2.5

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
COPY --chown=daemon:daemon --from=dvcfiles /dvc/model.pt /app/public/v1/model.pt
