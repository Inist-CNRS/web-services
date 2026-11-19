#!/bin/bash
# Wrapper [fork/exec] : lance align.py pour un job, écrit les résultats dans /tmp/retrieve/<id>/
# args: identifier source target lang min_score top_k no_hierarchy max_minutes
set -uo pipefail
IDENTIFIER="$1"; SOURCE_SPEC="$2"; TARGET_SPEC="$3"
LANG="${4:-fr,en}"; MIN_SCORE="${5:-0.7}"; TOP_K="${6:-5}"; NO_HIERARCHY="${7:-false}"; MAX_MINUTES="${8:-0}"

WORK="/tmp/upload/$IDENTIFIER"
OUT="/tmp/retrieve/$IDENTIFIER"
LOG="/tmp/logs/$IDENTIFIER.jsonl"
mkdir -p "$WORK" "$OUT" /tmp/logs

# Lire l'item unique passé par le fork sur stdin ; extraire le SKOS téléversé s'il existe
LINE=$(head -n 1)
UPLOAD=$(printf '%s' "$LINE" | node -pe 'try{JSON.parse(require("fs").readFileSync(0,"utf-8")).skos || ""}catch(e){""}' 2>/dev/null || true)
if [ -n "$UPLOAD" ]; then printf '%s' "$UPLOAD" > "$WORK/upload.skos"; fi

resolve() {
  case "$1" in
    loterreID:*) echo "/app/data/${1#loterreID:}.skos" ;;
    file)        echo "$WORK/upload.skos" ;;
    *)           echo "" ;;
  esac
}
SRC=$(resolve "$SOURCE_SPEC"); TGT=$(resolve "$TARGET_SPEC")
[ -n "$SRC" ] && [ -f "$SRC" ] || { echo "source introuvable: $SOURCE_SPEC" >&2; exit 2; }
[ -n "$TGT" ] && [ -f "$TGT" ] || { echo "target introuvable: $TARGET_SPEC" >&2; exit 2; }

echo "{\"timestamp\":$(date +%s000),\"generator\":\"loterre-align\",\"identifier\":\"$IDENTIFIER\",\"message\":\"Align start: $SOURCE_SPEC -> $TARGET_SPEC\"}" >> "$LOG"

EXTRA=""
[ "$NO_HIERARCHY" = "true" ] && EXTRA="--no-hierarchy"

EXIT=0
python3 /app/public/v1/align.py "$SRC" "$TGT" \
  -o "$OUT/alignments.rdf" \
  --lang "$LANG" --min_score "$MIN_SCORE" --top_k "$TOP_K" \
  --checkpoint "$WORK/checkpoint.jsonl" \
  --model /app/public/v1/loterre-align.gguf \
  --max-minutes "$MAX_MINUTES" $EXTRA >> "$LOG" 2>&1 || EXIT=$?

case "$EXIT" in
  0)
    [ -f "$OUT/report.json" ] || echo '{}' > "$OUT/report.json"
    tar -czf "/tmp/retrieve/$IDENTIFIER.tar.gz" -C "$OUT" alignments.rdf report.json
    echo "{\"timestamp\":$(date +%s000),\"generator\":\"loterre-align\",\"identifier\":\"$IDENTIFIER\",\"message\":\"Process completed\"}" >> "$LOG"
    echo "[{\"id\":\"$IDENTIFIER\",\"value\":\"done\"}]"
    ;;
  2) echo "bad input" >&2; exit 2 ;;
  3) echo "model unavailable" >&2; exit 3 ;;
  4) echo "llm error rate exceeded" >&2; exit 4 ;;
  124) echo "timeout" >&2; exit 124 ;;
  *) echo "internal error (exit $EXIT)" >&2; exit 1 ;;
esac
