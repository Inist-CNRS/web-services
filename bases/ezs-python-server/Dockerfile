FROM cnrsinist/python-node:py3.9-no24-1.1.0

RUN apt-get update && apt-get install -y --no-install-recommends tini=0.19.0-1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo '{ \
    "httpPort": 31976, \
    "configPath": "/app/config.json", \
    "dataPath": "/app/public" \
    }' > /etc/ezmaster.json

WORKDIR /app
RUN npm install --omit=dev dotenv-cli@10.0.0 && \
    npm install --omit=dev @ezs/core@4.0.2 && \
    npm install --omit=dev @ezs/analytics@2.3.5 && \
    npm install --omit=dev @ezs/basics@2.9.2 && \
    npm install --omit=dev @ezs/spawn@1.4.9 && \
    npm cache clean --force && \
    chmod a+w /app

# Make sure that .npm folder is readable by the daemon user
WORKDIR /usr/sbin/.npm
RUN chmod -R a+rwx /usr/sbin/.npm

WORKDIR /app/public
# See .dockerignore to see what files are copied
COPY . /app/

ENTRYPOINT [ "/usr/bin/tini", "-g", "--" ]
CMD [ "/app/docker-entrypoint.sh" ]

EXPOSE 31976
