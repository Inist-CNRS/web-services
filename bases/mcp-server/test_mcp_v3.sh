#!/bin/bash
# Test des outils ISTEX du serveur MCP : ./test_mcp_v3.sh
# Adresse du serveur (modifiable) : MCP_URL=http://mon-serveur:8000/mcp ./test_mcp_v3.sh
#
# Le serveur doit avoir chargé tools_config_v3.json. Ces appels interrogent la
# VRAIE API ISTEX (api.istex.fr) depuis le serveur MCP.
# Résultats trop longs : tronqués à l'affichage (variable MAX_CHARS, 1500 par défaut).

MCP_URL="${MCP_URL:-http://localhost:8000/mcp}"
MAX_CHARS="${MAX_CHARS:-1500}"
CT="Content-Type: application/json"
AC="Accept: application/json, text/event-stream"
CALL_ID=1
RESULT_FILE=/tmp/mcp_last_result.txt

# Réponses en flux SSE ("event: message / data: {...}") : ne garder que le JSON
sse_json() { sed -n 's/^data: //p' | tr -d '\r'; }

# Affiche le texte d'une réponse tools/call (tronqué) et l'enregistre dans $RESULT_FILE
print_result() {
  python3 -c '
import json, sys
limit = int(sys.argv[1])
try:
    data = json.load(sys.stdin)
except Exception as exc:
    print(f"[reponse illisible : {exc}]"); sys.exit(0)
if "error" in data:
    print("[ERREUR PROTOCOLE]", data["error"]); sys.exit(0)
result = data.get("result", {})
text = result["content"][0]["text"] if result.get("content") else ""
open(sys.argv[2], "w", encoding="utf-8").write(text)
label = "[ERREUR]" if result.get("isError") else "[OK]"
suffix = f"\n... (tronqué : {len(text)} caractères au total)" if len(text) > limit else ""
print(label, text[:limit] + suffix)
' "$MAX_CHARS" "$RESULT_FILE"
}

# call_tool <nom> '<arguments JSON>'
call_tool() {
  CALL_ID=$((CALL_ID + 1))
  curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" -d "{
    \"jsonrpc\": \"2.0\", \"id\": $CALL_ID, \"method\": \"tools/call\",
    \"params\": {\"name\": \"$1\", \"arguments\": $2}
  }" | sse_json | print_result
}

echo "=== 1. initialize (ouverture de session) ==="
curl -s -D /tmp/mcp_headers_v3.txt -X POST "$MCP_URL" -H "$CT" -H "$AC" -d '{
  "jsonrpc": "2.0", "id": 1, "method": "initialize",
  "params": {
    "protocolVersion": "2025-06-18",
    "capabilities": {},
    "clientInfo": {"name": "test-curl", "version": "1.0"}
  }
}' | sse_json | cut -c1-300

SID=$(grep -i '^mcp-session-id' /tmp/mcp_headers_v3.txt | sed 's/.*: //' | tr -d '\r')
echo "Session : $SID"
if [ -z "$SID" ]; then echo "Pas de session : vérifiez MCP_URL et que le serveur tourne."; exit 1; fi

curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" \
  -d '{"jsonrpc": "2.0", "method": "notifications/initialized"}' > /dev/null

echo
echo "=== 2. tools/list (outils ISTEX présents ?) ==="
curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" \
  -d '{"jsonrpc": "2.0", "id": 2, "method": "tools/list"}' | grep -o '"name":"istex_[a-z_]*"'

echo
echo "=== 3. istex_search : 3 résultats pour \"climate change\" (accès libre) ==="
call_tool istex_search '{"q": "title:\"climate change\"", "size": 3}'
DOC_ID=$(python3 -c 'import json; print(json.load(open("/tmp/mcp_last_result.txt"))["hits"][0]["id"])' 2>/dev/null)
echo "(identifiant du premier résultat, réutilisé plus bas : ${DOC_ID:-introuvable})"

echo
echo "=== 4. istex_search : résumés, tri par date décroissante ==="
call_tool istex_search '{"q": "climate change AND publicationDate:[2020 TO 2024]", "size": 2, "output": "title,abstract,publicationDate", "sortBy": "publicationDate[desc]"}'

echo
echo "=== 5. istex_facets : répartition par corpus (5 premiers) pour \"climate change\" ==="
call_tool istex_facets '{"q": "title:\"climate change\"", "facet": "corpusName[5]"}'

echo
echo "=== 6. istex_facets : répartition par année, facette imbriquée langue > année ==="
call_tool istex_facets '{"q": "title:\"climate change\"", "facet": "language[3]>publicationDate[perYear]"}'

echo
echo "=== 7. istex_get_document : notice du premier résultat de l'étape 3 ==="
if [ -n "$DOC_ID" ]; then call_tool istex_get_document "{\"id\": \"$DOC_ID\"}"; else echo "(ignoré : pas d'identifiant)"; fi

echo
echo "=== 8. istex_resolve_reference : par DOI (exemple de la doc ISTEX) ==="
call_tool istex_resolve_reference '{"doi": "10.1136/acupmed-2012-010183"}'

echo
echo "=== 9. istex_resolve_reference : par métadonnées (ISSN + volume + fascicule + page + auteur) ==="
call_tool istex_resolve_reference '{"issn": "0964-5284", "volume": 30, "issue": 4, "start_page": 298, "author": "Richard James Clark"}'

echo
echo "=== 10. istex_get_enrichments : liste des enrichissements d'un document (exemple de la doc) ==="
ENRICH_ID=087661D669BF44CA05AA6CE08ADD6399F6A439C4
call_tool istex_get_enrichments "{\"id\": \"$ENRICH_ID\"}"

echo
echo "=== ACCÈS CONTRÔLÉ : les 2 étapes suivantes nécessitent une IP autorisée par ISTEX. ==="
echo "=== Une erreur HTTP 401 ou 403 est NORMALE si l'IP du serveur MCP n'est pas autorisée. ==="

echo
echo "=== 11. istex_get_enrichments : catégories (multicat), 500 premiers caractères ==="
call_tool istex_get_enrichments "{\"id\": \"$ENRICH_ID\", \"type\": \"multicat\", \"max_chars\": 500}"

echo
echo "=== 12. istex_get_fulltext : texte intégral (txt) du premier résultat, 500 premiers caractères ==="
if [ -n "$DOC_ID" ]; then call_tool istex_get_fulltext "{\"id\": \"$DOC_ID\", \"format\": \"txt\", \"max_chars\": 500}"; else echo "(ignoré : pas d'identifiant)"; fi