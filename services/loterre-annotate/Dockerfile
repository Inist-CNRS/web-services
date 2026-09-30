# syntax=docker/dockerfile:1.4

# DICT_SOURCE sélectionne le stage qui fournit /dvc/dictionary à la ligne COPY
# finale : "dvc-files" (défaut, vrai pull DVC/webdav — CI/prod, à garder pour
# valider un déploiement réel) ou "dvc-files-local" (bypass, dev local
# uniquement — voir stage dvc-files-local ci-dessous). Ne jamais changer le
# défaut ici ; ws_deploy_docker_local.sh passe le override explicitement.
ARG DICT_SOURCE=dvc-files

# ── Stage 1 : pull dictionnaires via DVC ────────────────────────────────────
FROM  ghcr.io/astral-sh/uv:0.12.12-python3.10-trixie-slim AS dvc-files 
WORKDIR /dvc
RUN apt-get update && \ 
     apt-get install -y --no-install-recommends git=1:2.47.3-0+deb13u1 && \ 
     apt-get clean && \ 
     rm -rf /var/lib/apt/lists/*
RUN uv pip install --system --no-cache \
    dvc[webdav]==3.67.1 \
    pathspec==0.12.1
COPY ./dictionary.dvc /dvc
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git config --global init.defaultBranch master && \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)" && \
    dvc pull -v --jobs 1

# ── Stage 1bis : dictionnaire déjà présent en local (dev uniquement, bypass DVC) ──
# webdav.services.istex.fr a coupé la connexion à plusieurs reprises sur des
# sessions dvc pull longues (échecs à 12 min puis 51 min sur ~1,4 Go / 340
# fichiers, cf. historique de session) — inutile de re-télécharger quand
# dictionary/ est déjà sur le host pour un test local. Activé uniquement via
# --build-arg DICT_SOURCE=dvc-files-local + --build-context dictionary-local=...
# (voir ws_deploy_docker_local.sh) ; ne teste PAS le vrai pull DVC — pour ça,
# garder le défaut DICT_SOURCE=dvc-files (CI/prod).
FROM scratch AS dvc-files-local
COPY --from=dictionary-local . /dvc/dictionary

# COPY --from n'expand pas les ARG de façon fiable (contrairement à FROM) — ce
# stage picker sert juste à faire le choix dvc-files/dvc-files-local via FROM,
# pour que la COPY finale référence un nom de stage fixe, non paramétré.
FROM $DICT_SOURCE AS dict-picked

# ── Stage 2 : image principale ────────────────────────────────────────────────
# Debian trixie, Python 3.10, uv (voir bases/ezs-python-server/Dockerfile).
FROM cnrsinist/ezs-python-server:py3.10-no24-2.0.1

# LOTERRE_ANNOTATE_VERSION pilote quel tag git est installé ci-dessous — passé
# par ws_deploy_docker_local.sh (--build-arg, lu depuis VERSION à la racine).
# Docker invalide naturellement les couches RUN qui s'en servent dès que la
# valeur change (mécanisme standard, pas un hack) : une vraie release
# (--patch/--minor/--major dans build_push_package.sh) reconstruit toujours
# avec le code à jour ;
ARG LOTERRE_ANNOTATE_VERSION=1.11.0
ENV LOTERRE_ANNOTATE_VERSION=${LOTERRE_ANNOTATE_VERSION}
ENV GIT_REPO=https://github.com/stephane54/loterre-annotate.git
ENV LOTERRE_RESOURCES_DIR=/app/public/resources
ENV LOTERRE_REGISTRY=/app/public/configs/registry.yaml
# Pre-built spaCy match-index cache (see build_indexes_cached / warm_index_cache.py
# in the engine repo) — without this it would default to a site-packages-relative
# path, same problem the two vars above already work around. Nested inside
# dictionary/ deliberately: it travels with the existing dictionary.dvc pull +
# COPY below instead of needing its own DVC artifact/pull/COPY step.
ENV LOTERRE_INDEX_CACHE_DIR=/app/public/dictionary/.loterre_index_cache

# git : nécessaire au pip install "git+..." et au git clone ci-dessous — l'image
# de base le désinstalle à la fin de son propre build. Base trixie (maintenue) :
# plus besoin du contournement snapshot.debian.org de l'époque bullseye.
RUN apt-get update && \
    apt-get -y --no-install-recommends install git=1:2.47.3-0+deb13u1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# CACHEBUST : cas exceptionnel uniquement — un tag déplacé sans changer
# VERSION (--force-tag) ne ferait pas varier l'ARG ci-dessus, donc ne
# suffirait pas à invalider le cache. ws_deploy_docker_local.sh ne passe une
# valeur changeante que dans ce cas précis (sinon défaut constant = no-op).
ARG CACHEBUST=1

# Installe les modules Python loterre-annotate depuis GitHub
#
# torch CPU-only installé EN PREMIER, depuis l'index dédié PyTorch seul : sans
# ça, "git+...loterre-annotate" (qui dépend de sentence-transformers, donc de
# torch) serait résolu vers le wheel GPU par défaut de PyPI — ~6,3 Go de
# bibliothèques CUDA (nvidia-*-cu12, triton) jamais utilisées, ce projet étant
# CPU-only (voir CLAUDE.md). Une fois torch CPU satisfait, uv ne le réinstalle pas.
#
# numpy<2 : spaCy 3.7 impose thinc<8.3, dont les wheels sont compilés contre
# numpy 1.x — sans contrainte, uv résout numpy 2.x et spaCy plante à l'import
# ("numpy.dtype size changed, may indicate binary incompatibility").
RUN echo "cachebust=${CACHEBUST}" && \
    uv pip install --system --no-cache torch --index-url https://download.pytorch.org/whl/cpu && \
    uv pip install --system --no-cache \
        "loterre-annotate @ git+${GIT_REPO}@v${LOTERRE_ANNOTATE_VERSION}" \
        "numpy<2"

# Récupère resources/ et configs/registry.yaml depuis le même repo GitHub
# (shallow clone pour limiter la taille)
RUN echo "cachebust=${CACHEBUST}" && \
    git clone --depth 1 --branch "v${LOTERRE_ANNOTATE_VERSION}" \
        "${GIT_REPO}" /tmp/loterre-src && \
    cp -r /tmp/loterre-src/resources /app/public/resources && \
    mkdir -p /app/public/configs && \
    cp /tmp/loterre-src/configs/registry.yaml /app/public/configs/registry.yaml && \
    rm -rf /tmp/loterre-src

# Modèles spaCy (sm — léger, suffisant pour les profils entity_strict / term_recall)
RUN uv pip install --system --no-cache \
    "en_core_web_sm @ https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.7.1/en_core_web_sm-3.7.1-py3-none-any.whl" \
    "fr_core_news_sm @ https://github.com/explosion/spacy-models/releases/download/fr_core_news_sm-3.7.0/fr_core_news_sm-3.7.0-py3-none-any.whl"

RUN chown -R daemon:daemon /app/public/resources /app/public/configs

WORKDIR /app/public

COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json

# Dictionnaire depuis le stage DVC (ou dvc-files-local en dev, voir DICT_SOURCE)
COPY --chown=daemon:daemon --from=dict-picked /dvc/dictionary /app/public/dictionary/
