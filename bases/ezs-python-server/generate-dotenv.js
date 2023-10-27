const fs = require('fs');
const path = require('path');
const { environnement } = require('./config.json');
const vars = Object.keys(environnement)
    .filter(key => typeof environnement[key] !== 'object')
    .map(key => `${key}=${JSON.stringify(environnement[key])}`)
    .join('\n');
process.stdout.write('Writing .env file... ');
fs.writeFileSync(path.join(__dirname, '.env'), vars);
process.stdout.write('done.\n');
