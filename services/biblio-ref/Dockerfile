# syntax=docker/dockerfile:1.2
FROM python:3.9-slim-bullseye as build1
WORKDIR /dvc
COPY ./v1/annulled.csv.dvc /dvc
RUN apt update && apt -y install git
RUN pip install dvc[webdav]==3.39.0
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
RUN dvc pull -v
RUN dvc doctor


FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.6 as release

USER root
# Install all python dependencies
RUN pip install pandas==2.1.4 requests_ratelimiter==0.4.2

USER daemon
WORKDIR /app/public
# Declare files to copy in .dockerignore
# A modifier : (utiliser le .dockerignore)
COPY --chown=daemon:daemon ./v1 /app/public/v1

COPY --chown=daemon:daemon --from=build1 /dvc/annulled.csv /app/public/v1/annulled.csv
