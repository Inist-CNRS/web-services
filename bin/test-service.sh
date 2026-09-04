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

# Workarounds for hurl 8.0.1 panics (client.rs:220) with libcurl 8.5.0 (Ubuntu 24.04):
# the CURLINFO_HEADER_OUT debug callback is invoked with an empty buffer, both for
# HTTP/2 connections and for HTTP/1.1 requests with a 1 KiB-64 KiB body
# ("range start index 1 out of range for slice of length 0").
# --http1.1 avoids HTTP/2; --header 'Expect: 100-continue' (hurl strips it by
# default) makes curl send headers and body separately over HTTP/1.1.
# Remove both once hurl >= 8.1.0 is available.
npx hurl --test --jobs 1 --http1.1 --header 'Expect: 100-continue' --variable host="$HOST" "services/$SERVICE/tests.hurl"
