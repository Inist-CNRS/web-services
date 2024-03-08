#!/usr/bin/env bash
set +x
# include library

# shellcheck source=./library.sh
source ./library.sh
CLEAN="production"

while IFS=$'\n' read -r line; do

    # CLEAN : production mode => PROD / DEV = active / desactive data remove
    if [ -z "${CLEAN}" ] ; then
        CLEAN="production" # PROD|DEV
    fi
    echo "$(my_date):CLEAN:${CLEAN}" 1>&2

    # data  json stream  receive from collect procedure
    PROJECT=$(echo "$line"|node -pe 'JSON.parse(fs.readFileSync(0)).project')
	INPUT_CORPUS=$(echo "$line"|node -pe 'JSON.parse(fs.readFileSync(0)).corpus')
	LANG=$(echo "$line"|node -pe 'JSON.parse(fs.readFileSync(0)).language')
	TOPN=$(echo "$line"|node -pe 'JSON.parse(fs.readFileSync(0)).topn')
    WEBHOOK=$(echo "$line"|node -pe 'JSON.parse(fs.readFileSync(0)).url')
    PID=$$
    FILE_RESULT=$(echo "$line"|node -pe 'JSON.parse(fs.readFileSync(0)).file_result')
    # initialize MANIFEST.son
    echo -e "$(cat <<-END
    {
    "WS_NAME":"TERMSUITE",
    "DATE":"$(my_date)",
    "JOB_ID":"${PID}",
    "LOG_FILE_NAME":"${PID}.log",
    "RESULT_FILE":"${FILE_RESULT}",
    "RESULT_CODE":"${my_message[0]}"
    }
END
)" >| "${PROJECT}/${MANIFEST}"
	cmd="(
         echo \"$(my_date):TYDI-ID:$WEBHOOK\"  ;
         (check \"Collect_finished\" ${PROJECT}/${PID} 0 );
         (extract $PROJECT $INPUT_CORPUS $FILE_RESULT $LANG $TOPN $PID) ;
         (zip_forward $PROJECT $FILE_RESULT $WEBHOOK $PID) ;
         )
         >> ${PROJECT}/${PID}.log 2>&1"
    eval "$cmd"
    clean "$PROJECT" $PID $CLEAN
done < <(cat -)
