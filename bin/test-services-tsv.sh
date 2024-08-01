#!/usr/bin/env bash

# Usage: bin/test-services.sh [service-name]+

set -u # No uninitialized variable
set -o pipefail # Fail at first pipe error

SERVICES=("$@") # Get all parameters

printf "service\tversion\tresult\n"

for SERVICE in "${SERVICES[@]}"; do
    SERVICE=${SERVICE#services/} # Remove `services/`
    SERVICE=${SERVICE%/} # Remove trailing `/`

    VERSION=$(curl -q "https://$SERVICE.services.istex.fr" 2> /dev/null | jq -r '.info.version' 2> /dev/null)

    # Don't test if the package.json in the services/$SERVICE directory includes an "avoid-testing" key set to true
    if grep -q '"avoid-testing": true' "services/$SERVICE/package.json"; then
        printf "%s\t%s\tn/a\n" "$SERVICE" "$VERSION"
        continue
    fi

    npx hurl --test --continue-on-error --variable host="https://$SERVICE.services.istex.fr" "services/$SERVICE/tests.hurl" 2> /dev/null
    if [ $? -ne 0 ]; then
        printf "%s\t%s\t❌\n" "$SERVICE" "$VERSION"
    else
        printf "%s\t%s\t✅\n" "$SERVICE" "$VERSION"
    fi
done

exit 0
