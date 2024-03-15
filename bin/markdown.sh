#!/usr/bin/env bash

# Return the content of the file which path is given, replacing line return with
# "^M".
# @param {string} path of the file to convert
# @return {string}
function markdown2line() {
    local input_string
    input_string=$(cat "$1")
    input_string=${input_string//\[/\\\[}
    input_string=${input_string//\]/\\\]}
    input_string=${input_string//\(/\\\(}
    input_string=${input_string//\)/\\\)}
    input_string=${input_string//\//\\\/}
    echo "${input_string//$'\n'/^M}"
}

# Insert the description in the .ini file
# @param {string} path of the field to modify in the .ini metadata
# @param {string} path of the .md files to convert
function insert_description() {
    local DESCRIPTION
    local CONTAINS_DESCRIPTION
    local MARKDOWN_PATH
    local SLASH_PATH
    local INI_PATH
    FIELD_PATH=$1
    MARKDOWN_PATH=$2
    SLASH_PATH=${MARKDOWN_PATH//_//}
    INI_PATH=${SLASH_PATH/%.md/.ini}
    printf " - %s" "$INI_PATH"

    if [ ! -f "$INI_PATH" ]; then
        printf " X\n"
        return
    fi

    DESCRIPTION=$(markdown2line "$MARKDOWN_PATH")

    CONTAINS_DESCRIPTION=$(grep "$FIELD_PATH" "$INI_PATH")
    if [ "$CONTAINS_DESCRIPTION" = "" ]; then
        sed -i "/^post\.summary.*/a \
        $FIELD_PATH = $DESCRIPTION" "$INI_PATH"
    else
        sed -i "s/$FIELD_PATH =.*/$FIELD_PATH = $DESCRIPTION/" "$INI_PATH"
    fi
    printf " ✓\n"
}
