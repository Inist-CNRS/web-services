#!/usr/bin/env bash

# Usage: bin/test-services.sh [service-name]+

set -u # No uninitialized variable
set -o pipefail # Fail at first pipe error

SERVICES=("$@") # Get all parameters

for SERVICE in "${SERVICES[@]}"; do
    SERVICE=${SERVICE#services/} # Remove `services/`

    VERSION=$(curl -q "https://$SERVICE.services.istex.fr" 2> /dev/null | jq -r '.info.version' 2> /dev/null)
    printf "%s\t%s\n" "$SERVICE" "$VERSION"
done

exit 0
