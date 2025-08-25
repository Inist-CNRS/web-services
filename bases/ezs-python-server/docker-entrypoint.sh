#!/bin/sh

# Restore owner
find /app/public ! -user daemon -exec chown daemon:daemon {} \;
find /tmp ! -user daemon -exec chown daemon:daemon {} \;

cd /app || exit 1
node generate-dotenv.js
cd /app/public || exit 2

# Run ezs server as daemon user
su -s /bin/bash daemon -c "npx dotenv -e ../.env -- npx ezs --daemon ./"
