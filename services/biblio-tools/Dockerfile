# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

# WORKDIR /app

# Install all python dependencies
# RUN pip install --no-cache-dir \
#     unidecode==1.3.7

# Install all node dependencies
# RUN npm install --omit=dev \
#     @ezs/teeft@2.3.1 \
#     @ezs/strings@1.0.3 && \
#     npm cache clean --force

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
