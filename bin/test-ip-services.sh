#!/usr/bin/env bash

# Usage: bin/test-ip-services.sh [service-name]+

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

    SERVICE_LOCAL_URL=$(jq -r '.servers[1].url' "services/$SERVICE/swagger.json")
    SERVICE_LOCAL_IP=$(echo "$SERVICE_LOCAL_URL" | sed -e 's|vptdmservices.intra.inist.fr|192.168.128.151|' -e 's|vptdmjobs.intra.inist.fr|192.168.128.74|')
    npx hurl --jobs 1 --test --continue-on-error --variable host="$SERVICE_LOCAL_IP" "services/$SERVICE/tests.hurl"
done

exit 0
