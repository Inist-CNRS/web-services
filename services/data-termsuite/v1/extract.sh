#!/bin/bash
set +x

# Initialize SDKMAN / Java
export SDKMAN_DIR="/usr/sbin/.sdkman"
[[ -s "/usr/sbin/.sdkman/bin/sdkman-init.sh" ]] && source "/usr/sbin/.sdkman/bin/sdkman-init.sh"
JAR=/opt/termsuite-core-3.0.10.jar
language=${1:-en}
TOPN=${2:-500}

# Return the current date and time in ISO 8601 format.
function isoDate () {
    date +"%Y-%m-%dT%H:%M:%S"
}

nbTxt=0
while read -r line
do
    if [ -z "$corpus" ] ; then
        corpusField=$(echo "$line"|node -pe 'Object.keys(JSON.parse(fs.readFileSync(0).toString("utf-8").slice(0,-1))).filter(k=>!["id","value"].includes(k)).pop()')
        corpus=$(echo "$line"|node -pe 'JSON.parse(fs.readFileSync(0).toString("utf-8").slice(0,-1))["'"$corpusField"'"]')
        corpus=${corpus#uid:/} # Remove the "uid:/" prefix
        corpus_path=/tmp/retrieve/corpus/$corpus
        mkdir -p "$corpus_path"
    fi
    value=$(echo "$line"|node -pe 'JSON.parse(fs.readFileSync(0).toString("utf-8").slice(0,-1)).value.replace("\n","\\n").replaceAll("\"", "\\\"")')
    filename=$(echo "$line"|node -pe 'JSON.parse(fs.readFileSync(0).toString("utf-8").slice(0,-1)).id')
    echo "$value" > "$corpus_path/$filename"
    ((nbTxt++))
done

if [ "$nbTxt" -eq 0 ] ; then
    echo "$corpus corpus is empty" 1>&2
    exit 2
fi

if [ ! -r $JAR ] ; then
    echo "JAR not found: $JAR" 1>&2
    exit 3
fi

echo "$(isoDate):en:before extraction" 1>&2

result_path="/tmp/retrieve/$corpus-result.tsv"
java -Xms1g -Xmx6g -cp "$JAR" fr.univnantes.termsuite.tools.TerminologyExtractorCLI  \
    -c  "$corpus_path" \
    --tsv "$result_path" \
    -l "$language" -t /opt/treetagger \
    --post-filter-top-n="$TOPN" --post-filter-property=spec


echo "$(isoDate):en:after extraction" 1>&2

# EZS_METRICS=false npx @ezs/core -m /app/public/v1/tsv2json.cfg < "$result_path"
node ./v1/tsv2json.mjs < "$result_path"

# TODO: uncomment after development
# rm -rf "$corpus_path"
# rm -f "$result_path"
