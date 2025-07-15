#!/usr/bin/env bash

set -eu

# Wait until $1 is available, retrying every $3 milliseconds up to $2 times.
wait_for_url () {
    echo "Waiting for $1"
    printf 'GET %s\nHTTP 200' "$1" | hurl --retry "$2" --retry-interval "$3" --verbose> /dev/null;
    return 0
}

# branch name should be in the format:
# services/<service-name>/<comment>
BRANCH_NAME=$1
SERVICE_INTERMEDIATE=${BRANCH_NAME#services/} # remove services/ part
SERVICE_NAME=${SERVICE_INTERMEDIATE%/*}

echo "Starting container of $SERVICE_NAME"
cd "services/$SERVICE_NAME"
npm run start:dev

echo "Waiting server to be ready"
wait_for_url "http://localhost:31976" 30 30000

echo "Running hurl tests"
hurl --jobs 1 --variable host=http://localhost:31976 --test tests.hurl

echo "Stopping container of $SERVICE_NAME"
npm run stop:dev

echo "Done"
