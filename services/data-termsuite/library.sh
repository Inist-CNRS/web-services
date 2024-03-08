#!/usr/bin/env bash
set +x

# code = 0  => SUCCESS
# code = 1  => ERROR
# code = 2 =>  IN PROGRESS

declare -A my_message
my_message['0']="SUCCESS"
my_message['1']="FAILURE"
my_message['2']="IN PROGRESS"
MANIFEST=manifest.json

#
#  display date in iso-8601 format
#
function my_date () {

    date +"%Y-%m-%dT%H:%M:%S"

}

#
#  write messages in  *.log and MANIFEST.json
#
function check () {

    local mess=$1
    local pid=$2
    local code=$3

    # write message in LOGFILE
    echo "$(my_date):code=$code:${my_message[$code]}:message=$mess"  >> $pid.log

    # write message in MANIFEST
    if [[ "$code" -ne 0 ]] ; then
        sed -i "s/`echo ${my_message['0']}`/`echo ${my_message['1']}`/" "${PROJECT}/${MANIFEST}"
        return 1
    fi
    return 0
}

#
# remove all data ( input, output , log) from a extraction precoss
#
function clean () {

   local PROJECT=$1
   local PID_PATH=$1/$2
   local CLEAN=$3

   # write file.log  in EZ log
   cat "$PID_PATH".log 1>&2

   if [ "${CLEAN}" = "production" ] && [ -d "$PROJECT" ]; then
       rm -rf "$PROJECT"  > /dev/null  # delete input and output file from tmp
       return 0
   fi
}

#
# Lance une extraction termsuite à partir du corpus dezip
#
function extract () {

    local PROJECT=$1
    local F=$3
    local INPUT_CORPUS=$2
    local FILE_RESULT=$1/$F
    local LANG=$4
    local TOPN=$5
    local PID_PATH=$1/$6

    # check if termsuite is available on the machine
    JAR=$(ls /opt/termsuite-core-*.jar) && (check "termsuite-core.jar found on the machine " "$PID_PATH" 0)   || (check "Termsuite JAR not found " "$PID_PATH" 1)

    ############  extraction
    if [ -d "$INPUT_CORPUS" -a $? -eq 0 ]; then     # check if input corpus path exist
        NBR_TXT=$(ls -A "${INPUT_CORPUS}" | wc -l)
        if [ "$NBR_TXT" -gt 0  ]; then  # check if files exist
            # file result
            check "Extraction in progres on ${INPUT_CORPUS}, result in $FILE_RESULT ..."  "$PID_PATH" 0
            # execution termsuite
            java -Xms1g -Xmx6g -cp "$JAR" fr.univnantes.termsuite.tools.TerminologyExtractorCLI  -c  "$INPUT_CORPUS" --tsv "$FILE_RESULT" -l "$LANG" -t /opt/treetagger --post-filter-top-n="$TOPN" --post-filter-property=spec
            code_ts=$? && check "Termsuite final process code : $code_ts" "$PID_PATH" ${code_ts}
            # for test decom : rm -rf ${FILE_RESULT}
        else
            # empty file in dir
            check "[${NBR_TXT}] doc, no input data" "$PID_PATH" 1
        fi
    else  # no corpus dir !!
            check "Input directory [${INPUT_CORPUS}] not exist !!" "$PID_PATH" 1
    fi
}

#
# Envoie le  resultat de l extraction a l url du webhook
#
function zip_forward () {

    local PROJECT=$1
    local FILE=$2
    local FILE_RESULT=$1/$FILE
    local WEBHOOK=$3
    local PID=$4
    local PID_PATH=$1/$4

    # prepare zip
    local FILE_RESULT_ZIP=${FILE_RESULT}.zip

    if [ -s "${FILE_RESULT}" -a  $? -eq 0 ]; then     # check if a file result exist and operation before ok
        check "Result to zip found in ${FILE_RESULT_ZIP}" "$PID_PATH" 0
        zip -j "${FILE_RESULT_ZIP}" "${FILE_RESULT}" "$PROJECT/${MANIFEST}" "$PROJECT"/[0-9]*.log
        [[ $? -ne 0 ]] && check "Problem to compress  $FILE_RESULT !!" "$PID_PATH" 1
    else
        check "No data to deliver from $FILE_RESULT !!" "$PID_PATH" 1
        zip -j "${FILE_RESULT_ZIP}" "$PROJECT/${MANIFEST}"  "$PROJECT"/[0-9]*.log
        [[ $? -ne 0 ]] && check "Problem to compress  $FILE_RESULT !!" "$PID_PATH" 1
    fi

    # send the zip
    #local SEND=$(curl -X POST '${WEBHOOK}' -s -o /dev/null -w '%{http_code}' -H 'accept: application/json'  -H 'Content-Type: multipart/form-data'  -F 'file=@${FILE_RESULT_ZIP};type=application/zip' )
    ret_code="-s -w '%{http_code}'"
    #ret_code="-o /dev/null -s  -w '%{http_code}'"
    local SEND="curl -X POST '${WEBHOOK}' $ret_code -H 'accept: application/json'  -H 'Content-Type: multipart/form-data'  -F 'file=@${FILE_RESULT_ZIP};type=application/zip'"
    #write in log
    check "try forwarded to:'$SEND'" "$PID_PATH" 0

#curl -X 'POST' \
#  'https://terminologydesign-dev.migale.inrae.fr/api/extract/upload/?task=id' \
#  -H 'accept: application/json' \
#  -H 'Content-Type: multipart/form-data' \

    # try to send only one times

    curl_code=$(bash -c "$SEND")
    # curl_code=$(echo "$curl_code"| sed 's/\(.*\)\([2-5][0-9][0-9]\)\(.*\)/\2/')
    curl_code=${curl_code//[2-5][0-9][0-9]/}    # Replace any occurrence of a number between 200 and 599 with an empty string

    if  [[ $curl_code == 20* ]]   ; then
        check "Server return code:[$curl_code] - Result $FILE_RESULT_ZIP forwarded to $WEBHOOK" "$PID_PATH" 0
    else
        check "Server return code:[$curl_code] - Result $FILE_RESULT_ZIP NO forwarded to $WEBHOOK" "$PID_PATH" 1
    fi

}
