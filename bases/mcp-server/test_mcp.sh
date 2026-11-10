#!/bin/bash
# Test du serveur MCP, à lancer tel quel : ./test_mcp.sh
# Adresse du serveur (modifiable) : MCP_URL=http://mon-serveur:8000/mcp ./test_mcp.sh

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
echo "=== 3. tools/list ==="
curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" \
  -d '{"jsonrpc": "2.0", "id": 2, "method": "tools/list"}' | show

echo
echo "=== 4. tools/call : ner_tagger_geo (texte en anglais) ==="
curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" -d '{
  "jsonrpc": "2.0", "id": 3, "method": "tools/call",
  "params": {
    "name": "ner_tagger_geo",
    "arguments": {"value": "The conference took place in Nancy, a city in Lorraine, France, before moving to Berlin."}
  }
}' | show

echo
echo "=== 5. tools/call : text_summarize (texte en anglais) ==="
curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" -d '{
  "jsonrpc": "2.0", "id": 4, "method": "tools/call",
  "params": {
    "name": "text_summarize",
    "arguments": {"value": "Climate change is affecting ecosystems around the world. Rising temperatures are altering the distribution of species, while more frequent extreme weather events disrupt habitats. Researchers have shown that coral reefs are particularly vulnerable, with mass bleaching events becoming more common. At the same time, changes in rainfall patterns are affecting agriculture, making it harder for farmers to plan their harvests. Scientists argue that reducing greenhouse gas emissions and protecting natural habitats are both necessary to limit the long-term consequences."}
  }
}' | show

echo
echo "=== 6. tools/call : teeft_extraction_termes (texte en français) ==="
curl -s -X POST "$MCP_URL" -H "$CT" -H "$AC" -H "Mcp-Session-Id: $SID" -d '{
  "jsonrpc": "2.0", "id": 5, "method": "tools/call",
  "params": {
    "name": "teeft_extraction_termes",
    "arguments": {"value": "L extraction terminologique consiste à identifier automatiquement les termes les plus représentatifs d un document scientifique. Elle facilite l indexation et la recherche d information dans les grandes collections de publications."}
  }
}' | show