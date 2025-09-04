# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.12

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
