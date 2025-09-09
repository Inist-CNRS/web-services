FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.13

RUN apt-get update && apt-get install -y --no-install-recommends locales && apt-get clean && rm -rf /var/lib/apt/lists/*

# Génère la locale en_US.UTF-8
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen en_US.UTF-8

# Configure la locale par défaut
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install all python dependencies
RUN pip install --no-cache-dir \
    --index-url https://download.pytorch.org/whl/cpu \
    --extra-index-url https://pypi.org/simple \
    numpy==1.26.3 \
    CQE==2.0.2 \
    scikit-learn==1.2.2 \
    stemming==1.0.1 \
    six==1.16.0 \
    en-core-web-sm@https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.0.0/en_core_web_sm-3.0.0-py3-none-any.whl \
    en_core_web_trf@https://github.com/explosion/spacy-models/releases/download/en_core_web_trf-3.0.0/en_core_web_trf-3.0.0-py3-none-any.whl

# Install all node dependencies
RUN npm install --omit=dev \
    @ezs/teeft@2.3.2 \
    @ezs/strings@1.0.5 && \
    npm cache clean --force

# Fix permissions for CQE
RUN chmod -R 777 /usr/local/lib/python3.9/site-packages/CQE/ && \
    mkdir /usr/sbin/.local && \
    chown -R daemon:daemon /usr/sbin/.local

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
