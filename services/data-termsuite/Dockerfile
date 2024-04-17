# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.10

USER root

ENV \
    TT_VERSION=3.2.5 \
    TT_URL=http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/data \
    TERMSUITE_VERSION=3.0.10

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
    && chmod a+x /opt/treetagger/models \
    && rm -rf *.gz *.tgz cmd/ doc/

# Already present: curl
RUN apt update
RUN apt install -y zip

# Install TermSuite
RUN curl -L https://search.maven.org/remotecontent?filepath=fr/univ-nantes/termsuite/termsuite-core/${TERMSUITE_VERSION}/termsuite-core-${TERMSUITE_VERSION}.jar -o /opt/termsuite-core-${TERMSUITE_VERSION}.jar

# Prepare sdkman installation
RUN chmod a+wx /usr/sbin

# Use OpenJDK 8: https://github.com/termsuite/termsuite-core/issues/108
RUN curl -s "https://get.sdkman.io" | bash
RUN /bin/bash -c "source \"$HOME/.sdkman/bin/sdkman-init.sh\" && sdk install java 8.0.402-zulu "

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN chmod a+w /app/public/config.json && mv /app/public/config.json /app
