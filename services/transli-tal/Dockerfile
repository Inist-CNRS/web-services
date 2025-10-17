# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

WORKDIR /app
# Install all python dependencies
RUN pip install --no-cache-dir \
    regex==2025.9.18

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
