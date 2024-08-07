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

    npx hurl --test --continue-on-error --variable host="https://$SERVICE.services.istex.fr" "services/$SERVICE/tests.hurl"
done

exit 0
