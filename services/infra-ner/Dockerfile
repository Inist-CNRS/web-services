# syntax=docker/dockerfile:1.2

FROM cnrsinist/ezs-python-server:py3.10-no24-2.0.5

WORKDIR /app

RUN uv pip install --system --no-cache \
    requests==2.34.2 \
    pandas==2.3.3 \
    pyahocorasick==2.3.0 \
    rapidfuzz==3.14.5

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
