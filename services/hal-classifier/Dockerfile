# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.10

USER root

# Install Cython requirement
RUN apt update && apt install -y build-essential make gcc

RUN pip install Cython==0.29.37

# Install all python dependencies
# Using build isolation to fix compile error
# https://github.com/numpy/numpy/issues/24377#issuecomment-1671859253
RUN pip install --no-build-isolation \
    more-itertools==10.2.0 \
    numpy==1.19.1 \
    scipy==1.5.4 \
    fasttext==0.9.2 \
    faiss-cpu==1.7.2

# Clean-up
RUN apt remove -y --purge build-essential make gcc && \
    apt autoremove -y

# Install all node dependencies
# RUN npm install \
#     @ezs/teeft@2.3.1 \
#     @ezs/strings@1.0.3

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json
