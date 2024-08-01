FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.11

USER root

# Set libpostal home
ENV LIBPOSTAL_HOME=/usr/share/libpostal

WORKDIR ${LIBPOSTAL_HOME}
# Install required dependcies to build libpostal
RUN apt update && \
    apt install -y unzip curl autoconf automake libtool pkg-config build-essential git && \
    # Download libpostal \
    git clone https://github.com/openvenues/libpostal.git libpostal-master && \
    cd libpostal-master && \
    ## Reset to a fixed commit https://github.com/openvenues/libpostal/commit/8f2066b1d30f4290adf59cacc429980f139b8545
    git reset --hard 8f2066b && \
    cd .. && \
    # Build and install libpostal
    chmod +x libpostal-master && \
    cd libpostal-master && \
    ./bootstrap.sh && \
    ./configure --datadir=${LIBPOSTAL_HOME} && \
    make -j4 && \
    make install && \
    ldconfig && \
    cd .. && \
    rm -rf libpostal-master && \
    # Install node global dependecies
    npm install -g node-gyp && \
    # Install all node dependencies
    cd /app/public && \
    npm install \
    @ezs/libpostal@0.3.0 \
    @ezs/conditor@2.12.0 && \
    # Clean-up
    apt remove -y unzip curl autoconf automake libtool pkg-config build-essential git && \
    apt autoremove -y

# Install all python dependencies
RUN pip install backoff==2.2.1 ratelimit==2.2.1 requests==2.32.3

# Set workdir to the ws home directory
WORKDIR /app/public

# If issues with bindings with version of node higher than 20, try adding this line
# RUN cd node_modules/node_postal && npm run install

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN chmod a+w /app/public/config.json && mv /app/public/config.json /app
