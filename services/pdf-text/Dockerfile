# syntax=docker/dockerfile:1.2

FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.12

# Install all python dependencies
RUN pip install --no-cache-dir \
    spacy==2.3.5 \
    numpy==1.26.3 \
    requests==2.31.0 \
    Unidecode==1.3.2 \
    pypdf==4.3.1 \
    en_core_web_sm@https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-2.3.1/en_core_web_sm-2.3.1.tar.gz \
    fr_core_news_sm@https://github.com/explosion/spacy-models/releases/download/fr_core_news_sm-2.3.0/fr_core_news_sm-2.3.0.tar.gz \
    python-docx==1.1.2

# Install pdftohtml
RUN apt-get update && apt-get install -y --no-install-recommends poppler-utils=20.09.0-3.1+deb11u2 && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app/public

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
