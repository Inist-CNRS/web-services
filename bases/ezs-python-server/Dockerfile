FROM nikolaik/python-nodejs:python3.9-nodejs18-slim

WORKDIR /app
# See .dockerignore to see what files are copied
RUN apt update && apt install -y tini && \
    echo '{ \
    "httpPort": 31976, \
    "configPath": "/app/config.json", \
    "dataPath": "/app/public" \
    }' > /etc/ezmaster.json && \
    chmod a+w /app
USER pn
WORKDIR /app/public
RUN npm install dotenv-cli@7.3.0 && \
    npm install @ezs/core@3.4.0 && \
    npm install @ezs/analytics@2.2.1 && \
    npm install @ezs/basics@2.5.5 && \
    npm install @ezs/spawn@1.4.5
COPY . /app/

ENTRYPOINT [ "/usr/bin/tini", "-g", "--" ]
CMD [ "/app/docker-entrypoint.sh" ]
