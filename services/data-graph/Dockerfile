# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.12

USER root

RUN pip install \
    matplotlib==3.9.4 \
    networkx==3.2.1 \
    numpy==2.0.2 \
    scipy==1.13.1

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json
