FROM cnrsinist/ezs-python-saxon-server:py3.9-no16-1.0.0

USER daemon
WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
