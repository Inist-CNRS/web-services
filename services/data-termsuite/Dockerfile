# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.10-no24-2.0.5

ENV \
    TT_VERSION=3.2.5 \
    TT_URL=http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/data \
    TERMSUITE_VERSION=3.0.10 \
    SDKMAN_DIR=/opt/sdkman

# Install TreeTagger
WORKDIR /opt/treetagger
ADD ${TT_URL}/tree-tagger-linux-${TT_VERSION}.tar.gz \
    ${TT_URL}/tagger-scripts.tar.gz \
    ${TT_URL}/english.par.gz \
    ${TT_URL}/french.par.gz \
    ${TT_URL}/german.par.gz \
    ${TT_URL}/russian.par.gz \
    ${TT_URL}/italian.par.gz \
    ${TT_URL}/spanish.par.gz \
    ${TT_URL}/install-tagger.sh \
    /opt/treetagger/
RUN sh /opt/treetagger/install-tagger.sh \
    && mv lib models \
    && chmod -R a+rX /opt/treetagger \
    && rm -rf ./*.gz ./*.tgz cmd/ doc/

RUN apt-get update && apt-get install -y --no-install-recommends curl=8.14.1-2+deb13u7 unzip=6.0-29+deb13u1 zip=3.0-15+deb13u1 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install TermSuite
RUN curl -L https://search.maven.org/remotecontent?filepath=fr/univ-nantes/termsuite/termsuite-core/${TERMSUITE_VERSION}/termsuite-core-${TERMSUITE_VERSION}.jar -o /opt/termsuite-core-${TERMSUITE_VERSION}.jar && \
    # Prepare sdkman installation
    chmod a+wx /usr/sbin

# Use OpenJDK 8: https://github.com/termsuite/termsuite-core/issues/108
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -s "https://get.sdkman.io" | bash
RUN source "$SDKMAN_DIR/bin/sdkman-init.sh" && sdk install java 8.0.402-zulu \
    && chmod -R a+rX "$SDKMAN_DIR"

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
