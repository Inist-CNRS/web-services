# syntax=docker/dockerfile:1.2
FROM cnrsinist/python-node:py3.9-no16-1.0.1

USER root

RUN echo '{ \
    "httpPort": 31976, \
    "configPath": "/app/config.json", \
    "dataPath": "/app/public" \
    }' > /etc/ezmaster.json

USER daemon

WORKDIR /usr/sbin/.npm
RUN chmod -R a+rwx /usr/sbin/.npm

WORKDIR /app/public

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/

RUN npm install --omit=dev

EXPOSE 31976
CMD ["npm", "run", "ws:run"]
