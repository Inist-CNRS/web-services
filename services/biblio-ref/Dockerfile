# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

WORKDIR /app
# Install all python dependencies
RUN pip3 install --no-cache-dir \
    requests_ratelimiter==0.4.2 \
    thefuzz==0.22.1 \
    lxml==5.3.2

WORKDIR /app/public

# Declare files to copy in .dockerignore
# A modifier : (utiliser le .dockerignore)
COPY --chown=daemon:daemon . /app/public
COPY --chown=daemon:daemon ./config.json /app/config.json

# Download the list of annulled papers from PPS + process it
RUN curl -go /tmp/pps.csv 'https://dbrech.irit.fr/pls/apex/f?p=9999:300::IR[allproblematicpapers]_CSV'
RUN awk -F '","' 'index($1,"annulled") {print $2}' /tmp/pps.csv > /app/public/v1/annulled.csv && \
    rm /tmp/pps.csv && \
    python v1/csv2pickle.py v1/annulled.csv && \
    rm /app/public/v1/annulled.csv
