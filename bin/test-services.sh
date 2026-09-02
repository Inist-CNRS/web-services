#!/usr/bin/env bash

# Usage: bin/test-services.sh [service-name]+

set -u # No uninitialized variable
set -o pipefail # Fail at first pipe error

SERVICES=("$@") # Get all parameters

for SERVICE in "${SERVICES[@]}"; do
    SERVICE=${SERVICE#services/} # Remove `services/`

    # Exit if the package.json in the services/$SERVICE directory includes an "avoid-testing" key set to true
    if grep -q '"avoid-testing": true' "services/$SERVICE/package.json"; then
        echo "Skipping test for service $SERVICE"
        continue
    fi

    # --http1.1: workaround for hurl 8.0.1 panic (client.rs:220) when libcurl 8.5.0
    # reuses an HTTP/2 connection (empty header-out buffer). Remove once hurl >= 8.1.0 is available.
    npx hurl --test --jobs 1 --continue-on-error --http1.1 --variable host="https://$SERVICE.services.istex.fr" "services/$SERVICE/tests.hurl"
done

exit 0
