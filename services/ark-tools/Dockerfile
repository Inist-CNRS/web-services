FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.10

USER root

RUN npm install @ezs/ark@1.3.7

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
