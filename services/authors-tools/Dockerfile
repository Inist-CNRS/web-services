# syntax=docker/dockerfile:1.2

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
COPY ./v1/first-name/name_gender.pickle.dvc /dvc
COPY ./v1/corporate/abbreviations.json.dvc /dvc
RUN dvc pull -v

FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.12

USER root
# Install all python dependencies
RUN pip install \
    backoff==2.2.1 \
    pandas==2.2.2 \
    plac==1.4.3 \
    ratelimit==2.2.1 \
    requests==2.31.0 \
    unidecode==1.3.7

# Install all node dependencies
RUN npm install \
    @ezs/storage@3.2.3
#     @ezs/teeft@2.3.1 \
#     @ezs/strings@1.0.3

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json

COPY --chown=daemon:daemon --from=dvcfiles /dvc/name_gender.pickle /app/public/v1/first-name/name_gender.pickle
COPY --chown=daemon:daemon --from=dvcfiles /dvc/abbreviations.json /app/public/v1/corporate/abbreviations.json
