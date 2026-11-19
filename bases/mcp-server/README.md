# Serveur MCP classique (SDK officiel) dockerisé

## Contenu

- `server.py` — serveur MCP standard, basé sur `FastMCP` (SDK officiel
  `mcp`, branche 1.x), transport **Streamable HTTP** (JSON-RPC 2.0 sur
  HTTP, avec négociation `initialize`/`initialized` comme dans le
  protocole classique — pas de format custom).
- `tools_config.json` — description de vos web services existants ;
  un outil MCP est généré automatiquement pour chacun.
- `Dockerfile` — build de l'image, sur le modèle de votre Dockerfile
  habituel (tini en entrypoint).
- `requirements.txt` — dépendance unique : `mcp<2` (la branche 2.x du
  SDK a renommé/changé l'API `FastMCP`).

## Pourquoi garder votre image de base

Il n'existe pas d'image publique générique "Python + SDK MCP déjà
installé" faite pour y coller un serveur custom — les images MCP
pré-construites qu'on trouve sur Docker Hub/GHCR embarquent chacune
*leur propre* serveur (Playwright, Postgres, etc.), pas un socle
réutilisable. La solution la plus fiable reste donc de partir de votre
image de base habituelle et d'y installer le SDK (`pip install "mcp<2"`),
ce que fait ce Dockerfile.

## Build & lancement

```bash
docker build -t mon-mcp-server .
docker run -p 8000:8000 mon-mcp-server
```

Le serveur écoute alors en JSON-RPC 2.0 / Streamable HTTP sur
`http://<host>:8000/mcp` (endpoint standard MCP).

Test rapide (négociation initiale) :
```bash
curl -X POST http://localhost:8000/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'
```

## Variables d'environnement

- `MCP_HOST` (défaut `0.0.0.0`)
- `MCP_PORT` (défaut `8000`)
- `MCP_TOOLS_CONFIG` (défaut `/app/tools_config.json`)

## Ajouter vos web services

1. Copiez vos scripts dans l'image (via `COPY` dans le Dockerfile, ou
   montez-les en volume).
2. Ajoutez une entrée dans `tools_config.json` pointant vers leur
   chemin dans le conteneur.

Aucune modification de vos scripts n'est nécessaire — ils continuent
de fonctionner exactement comme avant (JSON sur stdin/stdout).

## Ce qui n'a pas pu être vérifié ici

Le SDK, le serveur et le protocole JSON-RPC ont été testés directement
(`pip install mcp<2` + requête `initialize` réelle, réponse conforme).
En revanche, je n'ai pas de Docker disponible dans cet environnement
pour lancer `docker build` sur ce Dockerfile précis : vérifiez le build
de votre côté, notamment la disponibilité de `pip`/`python3.10` dans
votre image de base `cnrsinist/python-node`.
