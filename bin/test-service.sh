#!/usr/bin/env bash

# Usage: bin/test-service.sh [<local|remote> [service-name]]

set -e # Exit at first error
set -u # No uninitialized variable
set -o pipefail # Fail at first pipe error

LOCATION=${1:-local}
SERVICE=${2:-base-line}

if [ ! -d "services/$SERVICE" ]; then
    echo "Could not find directory services/$SERVICE"
    exit 1
fi

if [ "$LOCATION" != "local" ] && [ "$LOCATION" != "remote" ]; then
    echo "Invalid location: $LOCATION"
    exit 2
fi

if [ "$LOCATION" = "local" ]; then
    HOST="http://localhost:31976"
else
    HOST="https://$SERVICE.services.istex.fr"
fi

npx hurl --test --variable host="$HOST" "services/$SERVICE/tests.hurl"
