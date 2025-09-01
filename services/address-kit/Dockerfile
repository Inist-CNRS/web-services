# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.12

WORKDIR /app
# Install all python dependencies
RUN pip install --no-cache-dir \
  pickleshare==0.7.5 \
  geopy==1.20.0 \
  iso3166==2.1.1 \
  unidecode==1.3.6

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
