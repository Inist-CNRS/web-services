FROM nikolaik/python-nodejs:python3.9-nodejs20-slim

WORKDIR /app
# See .dockerignore to see what files are copied
COPY . /app/
RUN mkdir -p /app/public && \
    chown -R pn:pn /app && \
    apt update && apt install -y tini && \
    echo '{ \
    "httpPort": 31976, \
    "configPath": "/app/config.json", \
    "dataPath": "/app/public" \
    }' > /etc/ezmaster.json
RUN su - pn -c "cd /app/public && \
    npm install @ezs/core@3.2.1 && \
    npm install @ezs/analytics@2.2.1 && \
    npm install @ezs/basics@2.5.5 && \
    npm install @ezs/spawn@1.4.5"

ENTRYPOINT [ "/usr/bin/tini", "-g", "--" ]
CMD [ "/app/docker-entrypoint.sh" ]
