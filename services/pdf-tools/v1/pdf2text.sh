#!/bin/bash
debug() { cat <<< "$@" 1>&2; }
NAME="/tmp/data-$RANDOM.dat"
COMP=${cpt:-0}
while IFS='$\n' read -r line; do
	COMP=`expr $COMP + 1`
	URI=$(echo $line|node -pe 'JSON.stringify(JSON.parse(fs.readFileSync(0)).id)')
	URL=$(echo $line|node -pe 'JSON.parse(fs.readFileSync(0)).value')
	PDF_FILE="/tmp/data-$RANDOM-$COMP.pdf"
	TXT_FILE="/tmp/data-$RANDOM-$COMP.txt"
	curl -s "${URL}" -H 'Referer;' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36' -H 'DNT: 1'  --compressed -L -o "$PDF_FILE"
	pdftotext -q $PDF_FILE $TXT_FILE
	echo -n "{\"id\": ${URI}, \"value\":"
	cat $TXT_FILE |node -pe 'JSON.stringify(fs.readFileSync(0).toString()).concat("}")'
	rm $PDF_FILE $TXT_FILE 1>&2 2>/dev/null
done < <(cat -)
