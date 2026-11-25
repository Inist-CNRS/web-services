#!/bin/bash
# Wrapper [fork/exec] : lance align.py pour un job, ecrit le resultat (tar.gz) dans /tmp/retrieve/<id> (FICHIER)
# args: identifier source target lang min_score top_k no_hierarchy max_minutes
set -uo pipefail
IDENTIFIER="$1"; SOURCE_SPEC="$2"; TARGET_SPEC="$3"
LANG="${4:-fr,en}"; MIN_SCORE="${5:-0.7}"; TOP_K="${6:-5}"; NO_HIERARCHY="${7:-false}"; MAX_MINUTES="${8:-0}"

APP_DIR="${ALIGN_APP_DIR:-/app/public}"
DATA_DIR="${ALIGN_DATA_DIR:-/app/data}"

WORK="/tmp/upload/$IDENTIFIER"
OUT="$WORK/out/$IDENTIFIER"
LOG="/tmp/logs/$IDENTIFIER"
mkdir -p "$WORK" "$OUT" /tmp/logs /tmp/retrieve

logline() { printf '{"timestamp":%s,"generator":"loterre-align","identifier":"%s","message":"%s"}\n' "$(date +%s000)" "$IDENTIFIER" "$1" >> "$LOG"; }

# Lire l'item unique passe par le fork sur stdin ; extraire le SKOS televerse s'il existe
LINE=$(head -n 1)
UPLOAD=$(printf '%s' "$LINE" | node -pe 'try{JSON.parse(require("fs").readFileSync(0,"utf-8")).skos || ""}catch(e){""}' 2>/dev/null || true)
if [ -n "$UPLOAD" ]; then printf '%s' "$UPLOAD" > "$WORK/upload.skos"; fi

resolve() {
  case "$1" in
    loterreID:*) echo "$DATA_DIR/${1#loterreID:}.skos" ;;
    file)        echo "$WORK/upload.skos" ;;
    *)           echo "" ;;
  esac
}
SRC=$(resolve "$SOURCE_SPEC"); TGT=$(resolve "$TARGET_SPEC")
[ -n "$SRC" ] && [ -f "$SRC" ] || { echo "source introuvable: $SOURCE_SPEC" >&2; exit 2; }
[ -n "$TGT" ] && [ -f "$TGT" ] || { echo "target introuvable: $TARGET_SPEC" >&2; exit 2; }

logline "Align start: $SOURCE_SPEC -> $TARGET_SPEC"

EXTRA=""
[ "$NO_HIERARCHY" = "true" ] && EXTRA="--no-hierarchy"

EXIT=0
python3 "$APP_DIR/v1/align.py" "$SRC" "$TGT" \
  -o "$OUT/alignments.rdf" \
  --lang "$LANG" --min_score "$MIN_SCORE" --top_k "$TOP_K" \
  --checkpoint "$WORK/checkpoint.jsonl" \
  --model "$APP_DIR/v1/loterre-align.gguf" \
  --max-minutes "$MAX_MINUTES" $EXTRA >> "$LOG" 2>&1 || EXIT=$?

case "$EXIT" in
  0)
    [ -f "$OUT/report.json" ] || echo '{}' > "$OUT/report.json"
    tar -czf "/tmp/retrieve/$IDENTIFIER" -C "$WORK/out" "$IDENTIFIER" || EXIT=$?
    logline "Process completed"
    printf '[{"id":"%s","value":"done"}]\n' "$IDENTIFIER"
    ;;
  2) echo "bad input" >&2; exit 2 ;;
  3) echo "model unavailable" >&2; exit 3 ;;
  4) echo "llm error rate exceeded" >&2; exit 4 ;;
  124) echo "timeout" >&2; exit 124 ;;
  *) echo "internal error (exit $EXIT)" >&2; exit 1 ;;
esac
