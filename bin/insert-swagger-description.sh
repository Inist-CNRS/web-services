#!/usr/bin/env bash

source bin/markdown.sh

if [ $# -ne 1 ]; then
    echo "Usage: $0 <service-directory>"
    exit 1
fi

SERVICE_DIRECTORY=${1}
cd "$SERVICE_DIRECTORY" || exit
insert_description_in_swagger
