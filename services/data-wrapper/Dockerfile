# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-saxon-server:py3.9-no24-1.0.9

WORKDIR /app

# Install all node dependencies
RUN npm install --omit=dev \
    @ezs/conditor@2.14.1 \
    @ezs/istex@1.5.12 \
    @ezs/xslt@1.3.33 && \
    npm cache clean --force

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/public/config.json

# Remove test files from ezs-python-saxon-server
RUN rm /app/public/parse.*
