#!/usr/bin/env bash

set -euo pipefail

wait_for_url () {
    echo "Waiting for $1"
    printf 'GET %s\nHTTP 200' "$1" | hurl --retry "$2" --retry-interval "$3" --verbose > /dev/null;
    return 0
}

cleanup() {
    docker stop dev 2>/dev/null || true
}
trap cleanup EXIT

# tag should be in the format:
# ws-<service-name>@<version>
TAG=$1
SERVICE_INTERMEDIATE=${TAG#ws-} # remove ws- part
SERVICE_NAME=${SERVICE_INTERMEDIATE%@*} # remove version part
VERSION=${SERVICE_INTERMEDIATE#*@} # remove service-name part

if [ ! -d "services/$SERVICE_NAME" ]; then
    echo "Could not find directory services/$SERVICE_NAME"
    exit 1
fi

IMAGE="cnrsinist/ws-${SERVICE_NAME}:${VERSION}"

cd "services/$SERVICE_NAME"

echo "Building & starting container of $SERVICE_NAME"
npm run start:dev

echo "Waiting server to be ready"
wait_for_url "http://localhost:31976" 10 30000

echo "Running hurl tests"
hurl --variable host=http://localhost:31976 --variable blocked=true --test --jobs 1 tests.hurl

echo "Stopping container of $SERVICE_NAME"
npm run stop:dev

echo "Tagging $IMAGE"
docker tag "cnrsinist/ws-${SERVICE_NAME}:latest" "$IMAGE"

echo "Pushing $IMAGE"
docker push "$IMAGE"

echo "Done"