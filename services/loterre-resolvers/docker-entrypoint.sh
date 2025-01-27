#!/bin/sh

# Restore owner
find /app/public ! -user daemon -exec chown daemon:daemon {} \;
find /tmp ! -user daemon -exec chown daemon:daemon {} \;

cd /app || exit 1
node generate-dotenv.js


# Restore databases
cd /app/data || exit 2

for tgz in /app/data/*.tgz
do
    su -s /bin/bash daemon -c "tar -xf $tgz"
    echo "Extracted $tgz"
done
echo "All databases restored"


# Run ezs server as daemon user
cd /app/public || exit 3

su -s /bin/bash daemon -c "npx dotenv -e ../.env -- npx ezs --daemon ./"
