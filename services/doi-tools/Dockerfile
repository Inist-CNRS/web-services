# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.8

USER root
# Install all python dependencies
RUN pip install \
    requests_ratelimiter==0.6.0

# Install all node dependencies
# RUN npm install \
#     @ezs/teeft@2.3.1 \
#     @ezs/strings@1.0.3

# Copy all files
USER daemon
WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
