# syntax=docker/dockerfile:1.2

FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.10

USER root
# Install all python dependencies
RUN pip install \
    gensim==4.3.2 \
    spacy==3.6.1 \
    spacy_lefff==0.5.1 \
    en-core-web-sm@https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.6.0/en_core_web_sm-3.6.0.tar.gz \
    pandas==1.4.0 \
    lxml==4.7.1 \
    fr_core_news_sm@https://github.com/explosion/spacy-models/releases/download/fr_core_news_sm-3.6.0/fr_core_news_sm-3.6.0-py3-none-any.whl \
    scipy==1.10.1 \
    prometheus-client==0.19.0

# Install all node dependencies
RUN npm install \
    "@ezs/analytics@2.2.2" \
    "@ezs/basics@2.6.0" \
    "@ezs/core@3.6.0" \
    "@ezs/spawn@1.4.5"
# Install CURL to get spacy_lefff model and put it at the right place
RUN apt update && apt -y install curl tar
RUN curl -L -O https://github.com/sammous/spacy-lefff-model/releases/latest/download/model.tar.gz
RUN mkdir /usr/local/lib/python3.9/site-packages/spacy_lefff/data/tagger
RUN tar -xf model.tar.gz -C /usr/local/lib/python3.9/site-packages/spacy_lefff/data/tagger
WORKDIR /app/public

ENV NUMBA_CACHE_DIR=/tmp/numba_cache
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json
