FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.11

USER root

# Set libpostal home
ENV LIBPOSTAL_HOME=/usr/share/libpostal

# Install required dependcies to build libpostal
RUN apt update && apt install -y unzip curl autoconf automake libtool pkg-config build-essential git

# Download libpostal
RUN mkdir ${LIBPOSTAL_HOME} && \
    cd ${LIBPOSTAL_HOME} && \
    git clone https://github.com/openvenues/libpostal.git libpostal-master && \
    cd libpostal-master && \
    git reset --hard 8f2066b
## Reset to a fixed commit https://github.com/openvenues/libpostal/commit/8f2066b1d30f4290adf59cacc429980f139b8545

# Build and install libpostal
WORKDIR ${LIBPOSTAL_HOME}
RUN chmod +x libpostal-master && \
    cd libpostal-master && \
    ./bootstrap.sh && \
    ./configure --datadir=${LIBPOSTAL_HOME} && \
    make -j4 && \
    make install && \
    ldconfig && \
    cd .. && \
    rm -rf libpostal-master

# Install node global dependecies
RUN npm install -g node-gyp

# Set workdir to the ws home directory
WORKDIR /app/public

# Install all node dependencies
RUN npm install \
    @ezs/libpostal@0.3.0 \
    @ezs/conditor@2.12.0

# If issues with bindings with version of node higher than 20, try adding this line
# RUN cd node_modules/node_postal && npm run install

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/

# Clean-up
RUN apt remove -y unzip curl autoconf automake libtool pkg-config build-essential git && \
    apt autoremove -y
