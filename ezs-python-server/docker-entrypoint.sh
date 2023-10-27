#!/bin/sh

exec su - pn -c "cd /app/public && npx ezs --daemon ./"
