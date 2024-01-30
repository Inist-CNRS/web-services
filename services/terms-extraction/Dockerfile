FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.7

USER root

# Install all node dependencies
RUN npm install \
    @ezs/teeft@2.3.1 \
    @ezs/strings@1.0.3

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
