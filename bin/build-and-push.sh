#!/usr/bin/env bash

set -euo pipefail

# tag should be in the format:
# ws-<service-name>@<version>
TAG=$1
SERVICE_INTERMEDIATE=${TAG#ws-} # remove ws- part
SERVICE_NAME=${SERVICE_INTERMEDIATE%@*} # remove version part

if [ ! -d "services/$SERVICE_NAME" ]; then
    echo "Could not find directory services/$SERVICE_NAME"
    exit 1
fi

echo "Building $TAG"

cd "services/$SERVICE_NAME"
npm run build
npm run publish
