FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

ARG saxon_ver=10.9
ENV SAXON_HOME=/usr/share/java/saxon

RUN apt-get update && apt-get install -y --no-install-recommends default-jre=2:1.11-72 \
    poppler-utils=20.09.0-3.1+deb11u2 \
    unzip=6.0-26+deb11u1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ADD \
    https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/${saxon_ver}/Saxon-HE-${saxon_ver}.jar \
    ${SAXON_HOME}/saxon.jar

ADD \
    http://archive.apache.org/dist/xmlgraphics/fop/binaries/fop-2.6-bin.zip \
    /fop.zip

WORKDIR /
RUN unzip fop.zip && \
    rm fop.zip && \
    chmod +x /fop-2.6/fop/fop && \
    mv /fop-2.6/fop /fop && \
    echo '#!/bin/sh' > /bin/xslt && \
    echo 'exec /usr/bin/java -jar' "${SAXON_HOME}/saxon.jar" '"$@"'>> /bin/xslt && \
    chmod a+rx,u+w /bin/xslt && \
    chmod u+rw,a+r ${SAXON_HOME}/saxon.jar
ENV PATH="/fop:$PATH"

WORKDIR /app
RUN npm --omit=dev install @ezs/xslt@1.3.32 && \
    npm cache clean --force
RUN chown daemon:daemon -R /app

WORKDIR /app
# See .dockerignore to see what files are copied
COPY --chown=daemon:daemon . /app/
