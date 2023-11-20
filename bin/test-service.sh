#!/usr/bin/env bash

# Usage: bin/test-service.sh [<local|remote> [service-name]]

set -e # Exit at first error
set -u # No uninitialized variable
set -o pipefail # Fail at first pipe error

LOCATION=${1:-local}
SERVICE=${2:-base-line}

npx hurl --test "services/$SERVICE/$LOCATION-tests.hurl"
