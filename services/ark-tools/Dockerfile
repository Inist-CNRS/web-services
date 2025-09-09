FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

WORKDIR /app

RUN npm install --omit=dev @ezs/ark@1.3.8 && \
    npm cache clean --force

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
