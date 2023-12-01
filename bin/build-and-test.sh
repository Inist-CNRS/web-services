#!/usr/bin/env bash

set -eu

wait_for_url () {
    echo "Waiting for $1"
    printf 'GET %s\nHTTP 200' "$1" | hurl --retry "$2" > /dev/null;
    return 0
}

SERVICE_NAME=${1%%/*}

echo "Starting container of $SERVICE_NAME"
cd "services/$SERVICE_NAME"
npm run start:dev

echo "Waiting server to be ready"
wait_for_url "http://localhost:31976" 10

echo "Ruuning hurl tests"
hurl --variable host=http://localhost:31976 --test tests.hurl

echo "Stopping container of $SERVICE_NAME"
npm run stop:dev

echo "Done"
