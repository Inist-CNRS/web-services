# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-pytorch-server:py3.9-no16-1.1.1

USER root
# Install all python dependencies
RUN apt update && apt install -y build-essential make gcc && \
    pip install --no-build-isolation \
    plac==1.4.3 \
    pybind11==2.12.0 \
    fasttext==0.9.2 && \
    apt remove -y --purge build-essential make gcc && \
    apt autoremove -y

# Install all node dependencies
RUN npm install \
    @ezs/storage@3.2.3

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json
