# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-pytorch-server:py3.9-no24-1.1.8

ENV HF_HOME=/app/.cache/huggingface
ENV NUMBA_CACHE_DIR=/tmp/numba_cache

WORKDIR /app
# Install all python dependencies
RUN pip install --no-cache-dir fasttext-wheel==0.9.2 numpy==1.26.3 nltk==3.9.1
RUN python3 -c \
 "import nltk; nltk.download('stopwords',download_dir='/usr/local/nltk_data'); nltk.download('averaged_perceptron_tagger_eng',download_dir='/usr/local/nltk_data'),nltk.download('punkt_tab',download_dir='/usr/local/nltk_data')"

# Temporary install of the latest ezs-core (until yearly update of base images)
RUN npm install --omit=dev @ezs/core@4.1.2 && \
    npm cache clean --force

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public
COPY --chown=daemon:daemon ./config.json /app/config.json