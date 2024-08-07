# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.11

USER root
# Install all python dependencies
RUN pip install \
    spacy==3.6.1 \
    xx-ent-wiki-sm@https://github.com/explosion/spacy-models/releases/download/xx_ent_wiki_sm-3.6.0/xx_ent_wiki_sm-3.6.0.tar.gz \
    numpy==1.26.4


# Install all node dependencies
# RUN npm install \
#     @ezs/strings@1.0.3

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json
