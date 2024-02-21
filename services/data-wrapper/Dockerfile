# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-saxon-server:py3.9-no16-1.0.2

USER root

# Install all node dependencies
RUN npm install \
    @ezs/conditor@2.10.8 \
    @ezs/istex@1.5.9 \
    @ezs/xslt@1.3.31

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
