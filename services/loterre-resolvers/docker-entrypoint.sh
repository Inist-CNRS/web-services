#!/bin/sh

# Restore owner
find /app/public ! -user daemon -exec chown daemon:daemon {} \;
find /tmp ! -user daemon -exec chown daemon:daemon {} \;

cd /tmp || exit 1
for tgz in databases/*.tgz; do su -s /bin/bash daemon -c "tar -xf $tgz"; done

cd /app || exit 2
node generate-dotenv.js

cd /app/public || exit 3

# Run ezs server as daemon user
su -s /bin/bash daemon -c "npx dotenv -e ../.env -- npx ezs --daemon ./"
