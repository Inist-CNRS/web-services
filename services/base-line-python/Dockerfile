FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.4

USER root
RUN pip install unidecode==1.3.7

USER daemon
WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY . /app/public/
