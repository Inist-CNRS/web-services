FROM cnrsinist/ezs-python-saxon-server:py3.9-no16-1.0.2

USER root

# Install all node dependencies
RUN npm install \
    @ezs/storage@3.2.3 \
    @ezs/xslt@1.3.31

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
