# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.11

ENV TT_VERSION=1.0.0

USER root

# Install required dependcies to build terms_tools
RUN apt update && \
    apt install -y unzip curl autoconf automake libtool pkg-config build-essential git
    # Download libpostal 
RUN pip install --upgrade pip
RUN pip install --no-cache-dir git+http://vxgit.intra.inist.fr:60000/git/schneist/terms_tools.git@$TT_VERSION#egg=terms_tools

# rendre possible installation des ressources stanza lors 1er execution (mkdir en user daemon)
RUN chmod 777 /usr/sbin/

WORKDIR /app/public

# If issues with bindings with version of node higher than 20, try adding this line
# RUN cd node_modules/node_postal && npm run install

# Declare files to copy in .dockerignore
#RUN chown -R daemon:daemon /usr/sbin/
COPY --chown=daemon:daemon . /app/public/
RUN  mv ./config.json /app/ && chmod a+w /app/config.json
