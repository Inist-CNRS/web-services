FROM cnrsinist/python-node:py3.9-no16-1.0.1

RUN apt update && apt install -y tini && \
    echo '{ \
    "httpPort": 31976, \
    "configPath": "/app/config.json", \
    "dataPath": "/app/public" \
    }' > /etc/ezmaster.json

WORKDIR /app
RUN npm install dotenv-cli@7.3.0 && \
    npm install @ezs/core@3.6.0 && \
    npm install @ezs/analytics@2.2.2 && \
    npm install @ezs/basics@2.6.0 && \
    npm install @ezs/spawn@1.4.5 && \
    chmod a+w /app

# Make sure that .npm folder is readable by the daemon user
WORKDIR /usr/sbin/.npm
RUN chmod -R a+rwx /usr/sbin/.npm

USER daemon
WORKDIR /app/public
# See .dockerignore to see what files are copied
COPY . /app/

ENTRYPOINT [ "/usr/bin/tini", "-g", "--" ]
CMD [ "/app/docker-entrypoint.sh" ]
