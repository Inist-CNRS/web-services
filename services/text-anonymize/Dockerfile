# syntax=docker/dockerfile:1.2

FROM cnrsinist/ezs-python-server:py3.10-no24-2.0.1

WORKDIR /app

# Install all python dependencies
RUN uv pip install --system --no-cache \
    spacy==3.8.11 \
    click==8.3.1 #spaCy core_news model dependency

# Download spaCy models
RUN python3 -m spacy download fr_core_news_sm && \
    python3 -m spacy download en_core_web_sm

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
