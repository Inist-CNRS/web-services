#!/usr/bin/env bash

set -euo pipefail

# branch name should be in the format:
# services/<service-name>/<comment>
BRANCH_NAME=$1
SERVICE_INTERMEDIATE=${BRANCH_NAME#services/} # remove services/ part
SERVICE_NAME=${SERVICE_INTERMEDIATE%/*}

if [ ! -d "services/$SERVICE_NAME" ]; then
    echo "Could not find directory services/$SERVICE_NAME"
    exit 1
fi

WEBDAV_LOGIN=$2
WEBDAV_PASSWORD=$3
WEBDAV_URL=$4

echo "Building .env for $SERVICE_NAME"

{
    echo "export WEBDAV_LOGIN=$WEBDAV_LOGIN"
    echo "export WEBDAV_PASSWORD=$WEBDAV_PASSWORD"
    echo "export WEBDAV_URL=$WEBDAV_URL"
} > "services/$SERVICE_NAME/.env"
