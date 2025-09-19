FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

# Set libpostal home
ENV LIBPOSTAL_HOME=/usr/share/libpostal

WORKDIR ${LIBPOSTAL_HOME}
# Install required dependencies to build libpostal
RUN apt-get update && \
    apt-get install -y --no-install-recommends autoconf=2.69-14 automake=1:1.16.3-2 build-essential=12.9 git=1:2.30.2-1+deb11u4 libtool=2.4.6-15 pkg-config=0.29.2-1 unzip=6.0-26+deb11u1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Download libpostal \
    git clone https://github.com/openvenues/libpostal.git libpostal-master && \
    cd libpostal-master && \
    ## Reset to a fixed commit https://github.com/openvenues/libpostal/commit/8f2066b1d30f4290adf59cacc429980f139b8545
    git reset --hard 8f2066b && \
    # Build and install libpostal
    chmod +x . && \
    ./bootstrap.sh && \
    ./configure --datadir=${LIBPOSTAL_HOME} && \
    make -j4 && \
    make install && \
    ldconfig && \
    cd .. && \
    rm -rf libpostal-master && \
    # Install node global dependencies
    npm install --omit=dev -g node-gyp@11.4.2 && \
    # Install all node dependencies
    cd /app && \
    npm install --omit=dev \
    @ezs/libpostal@0.3.1 \
    @ezs/conditor@2.13.4 && \
    npm cache clean --force && \
    # Clean-up
    apt-get remove -y autoconf automake unzip build-essential curl git libtool pkg-config && \
    apt-get autoremove -y

# Install all python dependencies
RUN pip install --no-cache-dir backoff==2.2.1 ratelimit==2.2.1 requests==2.32.3

WORKDIR /app/public

# If issues with bindings with version of node higher than 20, try adding this line
# RUN cd node_modules/node_postal && npm run install

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
