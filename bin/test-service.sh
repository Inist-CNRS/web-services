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
    # Exit if the package.json in the services/$SERVICE directory includes an "avoid-testing" key set to true
    if grep -q '"avoid-testing": true' "services/$SERVICE/package.json"; then
        echo "Skipping test for service $SERVICE"
        exit 0
    fi

    HOST="https://$SERVICE.services.istex.fr"
fi

npx hurl --test --jobs 1 --variable host="$HOST" "services/$SERVICE/tests.hurl"
