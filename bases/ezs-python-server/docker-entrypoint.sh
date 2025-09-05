#!/bin/sh

# Restore owner
find /app/public ! -user daemon -exec chown daemon:daemon {} \;
find /tmp ! -user daemon -exec chown daemon:daemon {} \;

cd /app || exit 1
node generate-dotenv.js
cd /app/public || exit 2

# Temporary fix for ezs bin
# Likely due to old npm and node versions
# TODO: remove when node version updated to 24
mv /app/node_modules/@ezs/core/bin/ezs /app/node_modules/@ezs/core/bin/ezs.js
rm /app/node_modules/.bin/ezs
ln -s /app/node_modules/@ezs/core/bin/ezs.js /app/node_modules/.bin/ezs

# Run ezs server as daemon user
su -s /bin/bash daemon -c "npx dotenv -e ../.env -- /app/node_modules/@ezs/core/bin/ezs.js --daemon ./"
