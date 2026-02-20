# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

WORKDIR /app/public

# Install all node dependencies
RUN npm install --omit=dev \
    commander@11.1.0 \
    @ezs/strings@1.0.5 && \
    npm cache clean --force

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json

# Extract CoL.txt
RUN gunzip v1/CoL.txt.gz

# Setup env variable
ENV LANG=C.UTF-8
