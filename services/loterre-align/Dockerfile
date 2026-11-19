# syntax=docker/dockerfile:1.2

# Stage 1: pull Loterre SKOS + LLM model from WebDAV via DVC
FROM ghcr.io/astral-sh/uv:0.12.12-python3.10-trixie-slim AS dvc-files
WORKDIR /dvc
RUN apt-get update && apt-get -y --no-install-recommends install git=1:2.47.3-0+deb13u1 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN uv pip install --system --no-cache dvc[webdav]==3.67.1 "pathspec==0.10.3"
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
COPY ./data/*.skos.dvc /dvc/data/
COPY ./v1/model_split.dvc /dvc/v1/
RUN dvc pull -v && \
    cat v1/model_split/* > v1/loterre-align.gguf && \
    rm -rf v1/model_split

##################################################################
# Stage 2: service on the CPU-only pytorch base (torch 2.3.0+cpu, transformers 4.41.2)
FROM cnrsinist/ezs-python-pytorch-server:py3.10-no24-2.0.2

WORKDIR /app
RUN uv pip install --system --no-cache \
    numpy==1.26.4 \
    sentence-transformers==3.0.1 \
    scikit-learn==1.5.2 \
    rdflib==7.1.1 \
    defusedxml==0.7.1 \
    unidecode==1.3.8 \
    tqdm==4.66.5 \
    llama-cpp-python==0.2.90 && \
    python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')"
ENV HF_HUB_OFFLINE=1

WORKDIR /app/public
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
COPY --chown=daemon:daemon --from=dvc-files /dvc/data/*.skos /app/data/
COPY --chown=daemon:daemon --from=dvc-files /dvc/v1/loterre-align.gguf /app/public/v1/loterre-align.gguf
