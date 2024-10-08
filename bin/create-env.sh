#!/usr/bin/env bash

set -euo pipefail

ARG=$1

if [[ "$ARG" =~  [^/]+/[^/]+/ ]]; then
    # branch name should be in the format:
    # services/<service-name>/<comment>
    BRANCH_NAME=$ARG
    SERVICE_INTERMEDIATE=${BRANCH_NAME#services/} # remove services/ part
    SERVICE_NAME=${SERVICE_INTERMEDIATE%/*}
else
    # tag should be in the format:
    # ws-<service-name>@<version>
    TAG=$ARG
    SERVICE_INTERMEDIATE=${TAG#ws-} # remove ws- part
    SERVICE_NAME=${SERVICE_INTERMEDIATE%@*} # remove version part
fi

if [ ! -d "services/$SERVICE_NAME" ]; then
    echo "Could not find directory services/$SERVICE_NAME"
    exit 1
fi

WEBDAV_LOGIN=$2
WEBDAV_PASSWORD=$3
WEBDAV_URL=$4
OPENALEX_API_KEY=$5
UNPAYWALL_API_KEY=$6

echo "Building .env for $SERVICE_NAME"

{
    echo "export WEBDAV_LOGIN=$WEBDAV_LOGIN"
    echo "export WEBDAV_PASSWORD=$WEBDAV_PASSWORD"
    echo "export WEBDAV_URL=$WEBDAV_URL"
    echo "export OPENALEX_API_KEY=$OPENALEX_API_KEY"
    echo "export UNPAYWALL_API_KEY=$UNPAYWALL_API_KEY"
} > "services/$SERVICE_NAME/.env"
