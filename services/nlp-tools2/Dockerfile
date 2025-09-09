# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

ENV EN_CORE_WEB_SM_VERSION=https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-2.3.1/en_core_web_sm-2.3.1.tar.gz

# Install all python dependencies
RUN pip install --no-cache-dir \
    numpy==1.26.3 \
    pycld3==0.22 \
    spacy==2.3.5 \
    en-core-web-sm@${EN_CORE_WEB_SM_VERSION}

WORKDIR /app/public

COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
