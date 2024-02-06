#!/usr/bin/env bash

MARKDOWN_PATH=$1
SLASH_PATH=${MARKDOWN_PATH//_//}
INI_PATH=${SLASH_PATH/%.md/.ini}
echo "$INI_PATH"
echo "-----------"

# Return the content of the file which path is given, replacing line return with
# "^M".
# @param {string} path of the file to convert
# @return {string}
function markdown2line() {
    local input_string
    input_string=$(cat "$1")
    echo "${input_string//$'\n'/^M}"
}

DESCRIPTION=$(markdown2line "$MARKDOWN_PATH")

CONTAINS_DESCRIPTION=$(grep "post.description" "$INI_PATH")

if [ "$CONTAINS_DESCRIPTION" = "" ]; then
    sed -i "/^post\.summary.*/a \
    post.description = $DESCRIPTION" "$INI_PATH"
else
    sed -i "s/post.description =.*/post.description = $DESCRIPTION/" "$INI_PATH"
fi
