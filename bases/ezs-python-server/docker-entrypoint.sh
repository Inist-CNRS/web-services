#!/bin/sh

cd /app
node generate-dotenv.js
cd /app/public
npx dotenv -e ../.env -- npx ezs --daemon ./
