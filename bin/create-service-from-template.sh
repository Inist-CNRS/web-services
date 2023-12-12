#!/usr/bin/env bash

# Usage: bin/create-service-from-template.sh <service-name>
set -euo pipefail

if [ ! -d "template" ]; then
    echo "Could not find directory template"
    exit 1
fi

SERVICE_NAME=$1

if [ -d "services/$SERVICE_NAME" ]; then
    echo "Service $SERVICE_NAME already exists"
    exit 2
fi

if ! [[ $SERVICE_NAME =~ ^[a-z][a-z0-9]*-[a-z][a-z0-9]*$ ]]; then
    echo "Error: Service name must comply with the pattern (two alphanumeric parts separated by a dash)."
    exit 3
fi

printf "Creating service ""%s"" from template\n\n" "$SERVICE_NAME"

printf "Short description: "
read -r SHORT_DESCRIPTION

printf "Long description : "
read -r SUMMARY

printf "Author name : "
read -r AUTHOR_NAME

printf "Author email: "
read -r AUTHOR_EMAIL

cp -r template "services/$SERVICE_NAME"

for FILE in "services/$SERVICE_NAME"/*; do
    if [ -f "$FILE" ]; then
        sed -i "s/{service}/$SERVICE_NAME/g" "$FILE"
        sed -i "s/{short_description}/$SHORT_DESCRIPTION/g" "$FILE"
        sed -i "s/{summary}/$SUMMARY/g" "$FILE"
        sed -i "s/{author_name}/$AUTHOR_NAME/g" "$FILE"
        sed -i "s/{author_email}/$AUTHOR_EMAIL/g" "$FILE"
    fi
done

# Add service to workspaces in package.json
node <<EOF
const packageJson = require('./package.json');
packageJson.workspaces = (packageJson.workspaces ?? [])
    .concat(['services/$SERVICE_NAME'])
    .sort()
    .reduce(
        (acc, curr) => acc.includes(curr) ? acc : [...acc, curr],
        []
    );

require('fs').writeFileSync(
    './package.json',
    JSON.stringify(packageJson, null, 2)
)
EOF
