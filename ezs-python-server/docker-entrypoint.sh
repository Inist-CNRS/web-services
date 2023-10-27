#!/bin/sh

exec su - pn -c "cd /app && node generate-dotenv.js && cd /app/public && npx dotenv -e ../.env -- npx ezs --daemon ./"
