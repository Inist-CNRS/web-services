# syntax=docker/dockerfile:1.2

FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.12

WORKDIR /app
# Install all python dependencies
RUN pip install --no-cache-dir \
    gensim==4.3.2 \
    spacy==3.6.1 \
    en-core-web-sm@https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.6.0/en_core_web_sm-3.6.0.tar.gz \
    pandas==1.4.0 \
    lxml==4.7.1 \
    fr_core_news_sm@https://github.com/explosion/spacy-models/releases/download/fr_core_news_sm-3.6.0/fr_core_news_sm-3.6.0-py3-none-any.whl \
    scipy==1.10.1 \
    prometheus-client==0.19.0

WORKDIR /app/public

ENV NUMBA_CACHE_DIR=/tmp/numba_cache
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
