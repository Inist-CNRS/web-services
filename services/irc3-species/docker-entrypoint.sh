#!/bin/sh

# Restore owner
find /app/public ! -user daemon -exec chown daemon:daemon {} \;
find /tmp ! -user daemon -exec chown daemon:daemon {} \;

# shellcheck disable=SC2164
cd /app
node generate-dotenv.js
# shellcheck disable=SC2164
cd /app/public

# Run irc3 daemon
su -s /bin/bash daemon -c "/app/public/v1/irc3_wrapper.sh ws"
npm run watcher &
# Run ezs server as daemon user
su -s /bin/bash daemon -c "npx dotenv -e ../.env -- npx ezs --daemon ./"
