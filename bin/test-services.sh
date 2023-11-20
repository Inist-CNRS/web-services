#!/usr/bin/env bash

# Usage: bin/test-services.sh [<local|remote> [service-name]+]

set -u # No uninitialized variable
set -o pipefail # Fail at first pipe error

LOCATION=${1:-local}

shift # Discard the first parameter
SERVICES=("$@") # Get all parameters from the 2nd one to the last

for SERVICE in "${SERVICES[@]}"; do
    SERVICE=${SERVICE#services/} # Remove `services/`
    npx hurl --test --continue-on-error "services/$SERVICE/$LOCATION-tests.hurl"
done

exit 0
