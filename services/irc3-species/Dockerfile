# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

RUN apt-get update && apt-get install -y --no-install-recommends perl=5.32.1-4+deb11u4 libjson-perl=4.03000-1 && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app/public

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
RUN mv ./docker-entrypoint.sh /app && chmod a+x /app/docker-entrypoint.sh

# Extract CoL.txt
RUN gunzip v1/CoL.txt.gz

# Setup env variable
ENV LANG=C.UTF-8

# Install all node dependencies
RUN npm install --omit=dev \
    @ezs/strings@1.0.5 && \
    npm cache clean --force
