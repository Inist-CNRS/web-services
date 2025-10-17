# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

# Install all python dependencies
RUN pip install --no-cache-dir \
    unidecode==1.3.7 \
    certifi==2025.8.3 \
    charset-normalizer==3.3.2 \
    idna==3.7 \
    requests==2.32.3 \
    urllib3==2.2.2 \
    networkx==3.2.1

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
