#!/bin/bash
# Test du serveur MCP (services à `value` non textuelle) : ./test_mcp_v2.sh
# Adresse du serveur (modifiable) : MCP_URL=http://mon-serveur:8000/mcp ./test_mcp_v2.sh
#
# Le serveur doit avoir été lancé avec MCP_TOOLS_CONFIG pointant sur tools_config_v2.json
# (dont les "url" sont à compléter).

MCP_URL="${MCP_URL:-http://localhost:8000/mcp}"
CT="Content-Type: application/json"
AC="Accept: application/json, text/event-stream"

# Réponses en flux SSE ("event: message / data: {...}") : on ne garde que le JSON
show() { sed -n 's/^data: //p' | tr -d '\r'; echo; }

echo "=== 1. initialize (ouverture de session) ==="
curl -s -D /tmp/mcp_headers.txt -X POST "$MCP_URL" -H "$CT" -H "$AC" -d '{
  "jsonrpc": "2.0", "id": 1, "method": "initialize",
  "params": {
    "protocolVersion": "2025-06-18",
    "capabilities": {},
    "clientInfo": {"name": "test-curl", "version": "1.0"}
  }
}' | show

SID=$(grep -i '^mcp-session-id' /tmp/mcp_headers.txt | sed 's/.*: //' | tr -d '\r')
echo "Session : $SID"
if [ -z "$SID" ]; then echo "Pas de session : vérifiez MCP_URL et que le serveur tourne."; exit 1; fi

echo
echo "=== 2. notifications/initialized (pas de réponse attendue) ==="
curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" \
  -d '{"jsonrpc": "2.0", "method": "notifications/initialized"}'
echo "OK"

echo
echo "=== 3. tools/list (noms des outils) ==="
curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" \
  -d '{"jsonrpc": "2.0", "id": 2, "method": "tools/list"}' | grep -o '"name":"[a-z_]*"'

echo
echo "=== 4. rnsr_info : value = OBJET {year, address} ==="
curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" -d '{
  "jsonrpc": "2.0", "id": 3, "method": "tools/call",
  "params": {
    "name": "rnsr_info",
    "arguments": {"value": {"year": "2021", "address": "University of Bordeaux, IMS, CNRS UMR5218, Talence, F-33405, France"}}
  }
}' | show

echo
echo "=== 5. orcid_disambiguation : value = OBJET avec LISTES ==="
curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" -d '{
  "jsonrpc": "2.0", "id": 4, "method": "tools/call",
  "params": {
    "name": "orcid_disambiguation",
    "arguments": {"value": [{
      "firstName": "Pascal",
      "lastName": "Cuxac",
      "email": ["pascal.cuxac@inist.fr"],
      "affiliations": ["Inist-CNRS"]
    }]}
  }
}' | show

echo
echo "=== 6. addresses_parse : value = texte, sortie = objet ==="
curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" -d '{
  "jsonrpc": "2.0", "id": 5, "method": "tools/call",
  "params": {
    "name": "addresses_parse",
    "arguments": {"value": "Inist-CNRS 2, rue Jean Zay CS 10310 F-54519 Vandoeuvre-les-Nancy France"}
  }
}' | show

echo
echo "=== 7. biblio_ref_validate : value = DOI, sortie = objet avec status ==="
curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" -d '{
  "jsonrpc": "2.0", "id": 6, "method": "tools/call",
  "params": {
    "name": "biblio_ref_validate",
    "arguments": {"value": "10.1038/nature12373"}
  }
}' | show

echo
echo "=== 8. loterre_resolvers_expand : sortie = objet ou \"n/a\" (une valeur connue, une inconnue) ==="
for VALUE in "CNRS" "toto"; do
  echo "--- value = $VALUE"
  curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" -d "{
    \"jsonrpc\": \"2.0\", \"id\": 7, \"method\": \"tools/call\",
    \"params\": {\"name\": \"loterre_resolvers_expand\", \"arguments\": {\"value\": \"$VALUE\"}}
  }" | show | cut -c1-600
done

echo
echo "=== 9. text_clustering : MODE LOT, 50 documents en anglais (5 thèmes) ==="
ITEMS=""
for i in $(seq 1 50); do
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

echo "(sortie tronquée aux 1500 premiers caractères)"
curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" -d "{
  \"jsonrpc\": \"2.0\", \"id\": 8, \"method\": \"tools/call\",
  \"params\": {\"name\": \"text_clustering\", \"arguments\": {\"items\": $ITEMS}}
}" | show | cut -c1-1500