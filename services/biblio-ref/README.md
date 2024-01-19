# ws-biblio-ref@0.0.0

Valide une référence bibliographique

Si un DOI est trouvé dans la référence bibliographique, valide la référence et indique si elle est rétractée

## Construction de l'image docker

Nécessite les variables d'environnement:

- `WEBDAV_URL`
- `WEBDAV_LOGIN`
- `WEBDAV_PASSWORD`

> **Note:** pour utiliser un *remote* webdav, le protocole de l'URL est `webdavs`.
> **Note:** n'oubliez pas d'exporter ces variables.

pour appeler `npm run build:dev` or `npm start:dev`.

> 📗 Suggestion: déclarez les variables dans le fichier `.env`  et n'oubliez pas de lancer `source .env`
> avant d'appeler `npm run build:dev` or `npm start:dev`.
