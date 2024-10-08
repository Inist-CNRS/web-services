# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.11

USER root
# Install all python dependencies
RUN apt update && apt install -y poppler-utils libmagic1

RUN pip3 install \
    requests_ratelimiter==0.4.2 \
    thefuzz==0.22.1 \
    refextract==1.1.4 \
    python-magic==0.4.27


WORKDIR /app/public

# Declare files to copy in .dockerignore
# A modifier : (utiliser le .dockerignore)
COPY --chown=daemon:daemon . /app/public
RUN mv ./config.json /app && chmod a+w /app/config.json

# Download the list of annulled papers from PPS + process it
RUN curl -go /tmp/pps.csv 'https://dbrech.irit.fr/pls/apex/f?p=9999:300::IR[allproblematicpapers]_CSV'
RUN awk -F '","' 'index($1,"annulled") {print $2}' /tmp/pps.csv > /app/public/v1/annulled.csv && \
    rm /tmp/pps.csv && \
    python v1/csv2pickle.py v1/annulled.csv && \
    rm /app/public/v1/annulled.csv
