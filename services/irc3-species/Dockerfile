# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.12

USER root

RUN apt update && apt install -y perl libjson-perl

WORKDIR /app/public

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json
RUN mv ./docker-entrypoint.sh /app && chmod a+x /app/docker-entrypoint.sh

# Extract CoL.txt
RUN gunzip v1/CoL.txt.gz

# Setup env variable
ENV LANG=C.UTF-8

# Install all node dependencies
RUN npm install \
    @ezs/strings@1.0.5
