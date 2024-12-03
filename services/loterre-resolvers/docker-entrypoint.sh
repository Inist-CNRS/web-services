#!/bin/sh

# Restore owner
find /app/public ! -user daemon -exec chown daemon:daemon {} \;
find /tmp ! -user daemon -exec chown daemon:daemon {} \;

cd /app || exit 1
node generate-dotenv.js

cd /app/public || exit 2

# Restore databases
for tgz in /app/data/*.tgz; do su -s /bin/bash daemon -c "tar -xf $tgz"; done
mv /app/public/databases /app/public/.databases

# Run ezs server as daemon user
su -s /bin/bash daemon -c "npx dotenv -e ../.env -- npx ezs --daemon ./"
