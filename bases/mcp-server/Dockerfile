# Il n'existe pas d'image de base "officielle" toute prête contenant déjà
# le SDK MCP pour du Python générique (seuls certains serveurs MCP publics
# ont leur propre image pré-construite sur Docker Hub / GHCR, pas une base
# réutilisable pour un serveur custom). On repart donc de votre image de
# base habituelle et on installe le SDK MCP dessus.
FROM cnrsinist/python-node:py3.10-no24-2.1.0

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends tini && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Dépendances Python du serveur MCP (SDK officiel, branche 1.x/FastMCP)
COPY requirements.txt /app/requirements.txt
RUN python3 -m pip install --no-cache-dir -r requirements.txt && \
    chmod a+w /app

# Code du serveur MCP + config des outils + vos web services existants
# (voir .dockerignore pour ce qui est effectivement copié)
COPY . /app/

ENV MCP_HOST=0.0.0.0 \
    MCP_PORT=8000 \
    MCP_TOOLS_CONFIG=/app/tools_config.json,/app/tools_config_v2.json,/app/tools_config_v3.json \
    PYTHONUNBUFFERED=1

ENTRYPOINT [ "/usr/bin/tini", "-g", "--" ]
CMD [ "python3", "/app/server.py" ]

EXPOSE 8000