#!/bin/sh

# Restore owner
find /app/public ! -user daemon -exec chown daemon:daemon {} \;
find /tmp ! -user daemon -exec chown daemon:daemon {} \;

cd /app || exit 1
node generate-dotenv.js


mkdir -p /app/data
chown -R daemon:daemon /app/data

# Restore SKOS files
cp /app/data0/*.skos /app/data

# Restore databases
cd /app/data || exit 2

for tgz in /app/data0/*.tgz
do
    su -s /bin/bash daemon -c "tar -xf $tgz"
    echo "Extracted $tgz"
done
echo "All databases restored"


# Run ezs server as daemon user
cd /app/public || exit 3

su -s /bin/bash daemon -c "npx dotenv -e ../.env -- npx ezs --daemon ./"
