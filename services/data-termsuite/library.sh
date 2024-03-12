#! /bin/bash
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
#  @param message
#  @param PID path
#  @param code
function check () {

    local mess=$1
    local pid=$2
    local code=$3

    # write message in LOGFILE
    echo "$(my_date):code=$code:${my_message[$code]}:message=$mess"  >> "$pid".log

    # write message in MANIFEST
    if [[ "$code" -ne 0 ]] ; then
        sed -i "s/${my_message[0]}/${my_message[1]}/" "$PROJECT/$MANIFEST"
        return 1
    fi
    return 0
}

#
# remove all data (input, output, log) from an extraction process
#
# @param PROJECT
# @param PID
# @param CLEAN if "production", remove PROJECT directory
function clean () {

   local PROJECT=$1
   local PID_PATH=$1/$2
   local CLEAN=$3

   # write file.log  in EZS log
   cat "$PID_PATH".log 1>&2

   if [ "${CLEAN}" = "production" ] && [ -d "$PROJECT" ]; then
       rm -rf "$PROJECT" > /dev/null  # delete input and output file from tmp
       return 0
   fi
}

#
# Launch TermSuite extraction from corpus zip
#
# @param project
# @param corpus
# @param TSV result filename
# @param language (en|fr)
# @param topn
# @param PID
function extract () {

    local PROJECT=$1
    local INPUT_CORPUS=$2
    local F=$3
    local FILE_RESULT=$PROJECT/$F
    local LANG=$4
    local TOPN=$5
    local PID_PATH=$PROJECT/$6

    # check if termsuite is available on the machine
    JAR=$(ls /opt/termsuite-core-*.jar) && (check "termsuite-core.jar found on the machine " "$PID_PATH" 0)   || (check "Termsuite JAR not found " "$PID_PATH" 1)

    ############  extraction
    if [ -d "$INPUT_CORPUS" -a $? -eq 0 ]; then     # check if input corpus path exist
        NBR_TXT=$(ls -A "${INPUT_CORPUS}" | wc -l)
        if [ "$NBR_TXT" -gt 0  ]; then  # check if files exist
            # file result
            check "Extraction in progress on ${INPUT_CORPUS}, result in $FILE_RESULT ..."  "$PID_PATH" 0
            # execution termsuite
            java -Xms1g -Xmx6g -cp "$JAR" fr.univnantes.termsuite.tools.TerminologyExtractorCLI  -c  "$INPUT_CORPUS" --tsv "$FILE_RESULT" -l "$LANG" -t /opt/treetagger --post-filter-top-n="$TOPN" --post-filter-property=spec
            code_ts=$? && check "Termsuite final process code : $code_ts" "$PID_PATH" ${code_ts}
        else
            # empty file in dir
            check "[${NBR_TXT}] doc, no input data" "$PID_PATH" 1
        fi
    else  # no corpus dir !!
            check "Input directory [${INPUT_CORPUS}] does not exist !!" "$PID_PATH" 1
    fi
}

#
# Send the extraction result to the webhook URL
#
# @param project
# @param TSV result filename
# @param webhook url
# @param PID
function zip_forward () {

    local PROJECT=$1
    local FILE=$2
    local FILE_RESULT=$PROJECT/$FILE
    local WEBHOOK=$3
    local PID=$4
    local PID_PATH=$PROJECT/$PID

    # prepare zip
    local FILE_RESULT_ZIP=${FILE_RESULT}.zip

    if [ -s "$FILE_RESULT" -a  $? -eq 0 ]; then     # check if a file result exists and operation before ok
        check "Result to zip found in ${FILE_RESULT_ZIP}" "$PID_PATH" 0
        if ! zip -j "$FILE_RESULT_ZIP" "$FILE_RESULT" "$PROJECT/$MANIFEST" "$PROJECT"/[0-9]*.log; then
            check "Problem to compress $FILE_RESULT !!" "$PID_PATH" 1
        fi
    else
        check "No data to deliver from $FILE_RESULT !!" "$PID_PATH" 1
        if ! zip -j "$FILE_RESULT_ZIP" "$PROJECT/$MANIFEST"  "$PROJECT"/[0-9]*.log; then
            check "Problem to compress $FILE_RESULT !!" "$PID_PATH" 1
        fi
    fi

    # send the zip
    ret_code="-s -w '%{http_code}'"
    local SEND="curl -X POST '$WEBHOOK' $ret_code -H 'accept: application/json' -H 'Content-Type: multipart/form-data' -F 'file=@${FILE_RESULT_ZIP};type=application/zip'"
    # write in log
    check "Try fowarded to:'$SEND'" "$PID_PATH" 0

    # try to send only one time

    curl_code=$(bash -c "$SEND")
    curl_code=$(echo "$curl_code"| sed 's/\(.*\)\([2-5][0-9][0-9]\)\(.*\)/\2/')

    if  [[ $curl_code == 20* ]]; then
        check "Server return code:[$curl_code] - Result $FILE_RESULT_ZIP forwarded to $WEBHOOK" "$PID_PATH" 0
    else
        check "Server return code:[$curl_code] - Result $FILE_RESULT_ZIP NO forwarded to $WEBHOOK" "$PID_PATH" 1
    fi
}
