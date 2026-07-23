# ws-data-geonames@1.2.3

Detect Localisation entity from a text, and align each entity with geonames referential when possible.

In a given text, extract LOCATION named entity, and align them with the geonames referential whenever its possible.

## .env

Pour pouvoir démarrer l'image, il faut un fichier `.env` contenant la clé d'API
ILAAS et les variables d'accès au remote DVC:

```env
ILAAS_API_KEY=real-api-key
export WEBDAV_URL=real-webdav-url
export WEBDAV_LOGIN=real-login
export WEBDAV_PASSWORD=real-password
```
