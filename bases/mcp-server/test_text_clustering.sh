#!/bin/bash
# Test dédié à text_clustering (+ text_clustering_retrieve en rattrapage).
# Lancer : ./test_text_clustering.sh
# Adresse du serveur : MCP_URL=http://mon-serveur:8000/mcp ./test_text_clustering.sh
#
# Le serveur doit avoir chargé tools_config_v2.json (ou le fichier fusionné
# qui le contient), avec les vraies URLs de text_clustering renseignées.

MCP_URL="${MCP_URL:-http://localhost:8000/mcp}"
CT="Content-Type: application/json"
AC="Accept: application/json, text/event-stream"

# Nombre de tentatives de rattrapage et délai entre deux tentatives (secondes)
MAX_RETRIES="${MAX_RETRIES:-8}"
RETRY_DELAY="${RETRY_DELAY:-10}"

# Réponses en flux SSE ("event: message / data: {...}") : ne garder que le JSON
sse_json() { sed -n 's/^data: //p' | tr -d '\r'; }

# Lit le JSON d'une réponse tools/call sur stdin, affiche son contenu texte
call_result_text() {
  python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
    result = data.get("result", {})
    content = result.get("content", [])
    text = content[0]["text"] if content else ""
    print(text)
    sys.exit(1 if result.get("isError") else 0)
except Exception as e:
    print(f"(reponse illisible: {e})")
    sys.exit(2)
'
}

# Extrait le jeton d'un message d'erreur du type "Jeton : 'tok0'."
extract_token() {
  python3 -c '
import re, sys
m = re.search(r"[Jj]eton\s*:?\s*.(\x27|\")([^\x27\"]+)\1", sys.stdin.read())
print(m.group(2) if m else "")
'
}

echo "=== 1. initialize (ouverture de session) ==="
curl -s -D /tmp/mcp_headers_tc.txt -X POST "$MCP_URL" -H "$CT" -H "$AC" -d '{
  "jsonrpc": "2.0", "id": 1, "method": "initialize",
  "params": {
    "protocolVersion": "2025-06-18",
    "capabilities": {},
    "clientInfo": {"name": "test-curl", "version": "1.0"}
  }
}' | sse_json

SID=$(grep -i '^mcp-session-id' /tmp/mcp_headers_tc.txt | sed 's/.*: //' | tr -d '\r')
echo "Session : $SID"
if [ -z "$SID" ]; then echo "Pas de session : vérifiez MCP_URL et que le serveur tourne."; exit 1; fi

curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" \
  -d '{"jsonrpc": "2.0", "method": "notifications/initialized"}' > /dev/null

echo
echo "=== 2. Construction d'un corpus de test (55 documents, 5 thèmes en anglais) ==="
ITEMS=""
for i in $(seq 1 55); do
  case $((i % 5)) in
    0) T="Soil nutrients and crop yield in a wheat farming field trial number $i" ;;
    1) T="Deep neural networks for image classification, experiment number $i" ;;
    2) T="Coral reef bleaching and ocean warming survey, site number $i" ;;
    3) T="Clinical trial of a new cancer immunotherapy treatment, cohort number $i" ;;
    4) T="Quantum computing error correction with superconducting qubits, run number $i" ;;
  esac
  ITEMS="$ITEMS{\"id\": \"doc$i\", \"value\": \"$T\"},"
done
ITEMS="[${ITEMS%,}]"
echo "OK (55 documents prêts)"

echo
echo "=== 3. tools/call : text_clustering ==="
RAW=$(curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" -d "{
  \"jsonrpc\": \"2.0\", \"id\": 2, \"method\": \"tools/call\",
  \"params\": {\"name\": \"text_clustering\", \"arguments\": {\"items\": $ITEMS}}
}" | sse_json)

echo "$RAW" | call_result_text
STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  echo
  echo "=== Résultat obtenu directement (pas de rattrapage nécessaire) ==="
  exit 0
fi

TOKEN=$(echo "$RAW" | call_result_text 2>/dev/null | extract_token)
if [ -z "$TOKEN" ]; then
  echo
  echo "=== Échec sans jeton exploitable : voir le message ci-dessus (vraie erreur, pas un simple délai) ==="
  exit 1
fi

echo
echo "=== 4. Rattrapage via text_clustering_retrieve (jeton : $TOKEN) ==="
for i in $(seq 1 "$MAX_RETRIES"); do
  echo "--- tentative $i/$MAX_RETRIES (attente ${RETRY_DELAY}s) ---"
  sleep "$RETRY_DELAY"

  RAW=$(curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" -d "{
    \"jsonrpc\": \"2.0\", \"id\": $((10 + i)), \"method\": \"tools/call\",
    \"params\": {\"name\": \"text_clustering_retrieve\", \"arguments\": {\"token\": \"$TOKEN\"}}
  }" | sse_json)

  echo "$RAW" | call_result_text
  STATUS=$?

  if [ "$STATUS" -eq 0 ]; then
    echo
    echo "=== Résultat obtenu après rattrapage (tentative $i) ==="
    exit 0
  fi
done

echo
echo "=== Toujours pas prêt après $MAX_RETRIES tentative(s). Jeton pour continuer manuellement : $TOKEN ==="
exit 1