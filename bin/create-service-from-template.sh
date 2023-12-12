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

echo -ne "Copying template...    \r"

cp -r template "services/$SERVICE_NAME"

echo -ne "Customizing service... \r"

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
echo -ne "Adding workspace...    \r"

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

# Add service to list of services in README
echo -ne "Updating README...     \r"

sed -n '1,/## Services/p' < README.md > README.tmp
echo "" >> README.tmp
node <<EOF >> README.tmp
const workspaces = require('./package.json').workspaces;
const services = workspaces.reduce(
    (acc, curr) => {
        if (!curr.startsWith('services/')) {
            return acc;
        }
        const service = curr.split('/')[1];
        return acc +
            \`- [\${service}](./services/\${service}) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-\${service}.svg)](https://hub.docker.com/r/cnrsinist/ws-\${service}/)\n\`;
    }, ''
);
console.log(services.substr(0, services.length - 1));
EOF
mv README.md README.back
mv README.tmp README.md
rm README.back

echo -e "\rDone                    "
