# syntax=docker/dockerfile:1.2

FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.11
USER root
# Install all python dependencies
RUN pip install \
    spacy==2.3.5 \
    requests==2.31.0 \
    Unidecode==1.3.2 \
    en_core_web_sm@https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-2.3.1/en_core_web_sm-2.3.1.tar.gz \
    fr_core_news_sm@https://github.com/explosion/spacy-models/releases/download/fr_core_news_sm-2.3.0/fr_core_news_sm-2.3.0.tar.gz

RUN apt update && apt install -y pdftohtml 

WORKDIR /app/public

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json
