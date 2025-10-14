FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.30.2-1+deb11u5 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir dvc[webdav]==3.42.0
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
COPY ./v1/aiAbstract-model.pt.dvc /dvc
RUN dvc pull -v

FROM cnrsinist/ezs-python-pytorch-server:py3.9-no24-1.1.8

# Uninstall transformers due to a bug with latest version and flair
RUN pip install --no-cache-dir \
    transformers==4.48.2 \
    flair==0.15.0
# Install all python dependencies

# Declare files to copy in .dockerignore
WORKDIR /app/public
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
COPY --chown=daemon:daemon --from=dvc-files /dvc/aiAbstract-model.pt /app/public/v1/aiAbstract-model.pt
