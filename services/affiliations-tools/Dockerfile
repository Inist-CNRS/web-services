FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.8

USER root

# Install libpostal
ENV LIBPOSTAL_HOME=/usr/share/libpostal

RUN apt update && apt install -y unzip curl autoconf automake libtool pkg-config build-essential

ADD \
    https://codeload.github.com/openvenues/libpostal/zip/refs/heads/master \
    ${LIBPOSTAL_HOME}/libpostal.zip

WORKDIR ${LIBPOSTAL_HOME}

RUN unzip libpostal.zip && \
    chmod +x libpostal-master && \
    cd libpostal-master && \
    ./bootstrap.sh && \
    ./configure --datadir=${LIBPOSTAL_HOME} && \
    make -j4 && \
    make install && \
    ldconfig && \
    cd .. && \
    rm -rf libpostal-master && \
    rm libpostal.zip

# Install all node dependencies
RUN npm install \
    node-gyp \
    @cymen/node-postal@2.0.5 \
    @ezs/libpostal@0.2.3 \
    @ezs/conditor@2.10.7

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
