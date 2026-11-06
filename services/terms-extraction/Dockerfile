FROM cnrsinist/ezs-python-server:py3.10-no24-2.0.5

RUN apt-get update && \
    apt-get install -y --no-install-recommends locales=2.41-12+deb13u4 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Génère la locale en_US.UTF-8
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen en_US.UTF-8

# Configure la locale par défaut
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install all python dependencies
# CQE is installed separately below, without its declared dependencies:
# it requires spacy-transformers, which needs tokenizers<0.11 (no wheel for
# Python 3.10) although CQE only uses spacy at runtime.
# spacy and its model are pinned to keep the quantity extraction results stable.
RUN uv pip install --system --no-cache \
    --extra-index-url https://pypi.org/simple \
    numpy==1.26.3 \
    spacy==3.0.9 \
    spacy_download==1.1.0 \
    fuzzywuzzy==0.18.0 \
    python-Levenshtein==0.27.3 \
    ordered-set==4.1.0 \
    scikit-learn==1.2.2 \
    stemming==1.0.1 \
    six==1.16.0 && \
    uv pip install --system --no-cache --no-deps CQE==2.0.3

# Install all node dependencies
RUN npm install --omit=dev \
    @ezs/teeft@2.3.5 \
    @ezs/strings@1.0.6 && \
    npm cache clean --force

# Fix permissions for CQE
RUN CQE_DIR=$(python -c "import CQE, os; print(os.path.dirname(CQE.__file__))") && \
    chmod -R 777 "$CQE_DIR" && \
    mkdir /usr/sbin/.local && \
    chown -R daemon:daemon /usr/sbin/.local && \
    rm -rf "$CQE_DIR/unit_models" && \
    python -c "from CQE import CQE; CQE.CQE()"

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
