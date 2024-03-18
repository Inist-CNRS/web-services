# syntax=docker/dockerfile:1.2
FROM cnrsinist/python-node:py3.9-no16-1.0.1

USER root

RUN echo '{ \
    "httpPort": 3000, \
    "configPath": "/app/config.json", \
    "dataPath": "/app/public" \
    }' > /etc/ezmaster.json

WORKDIR /app/public

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
