# ws-biblio-ref@1.0.0

Valide une référence bibliographique

Si un DOI est trouvé dans la référence bibliographique, valide la référence et indique si elle est rétractée

## Construction de l'image docker

Nécessite les variables d'environnement:

- `WEBDAV_URL`
- `WEBDAV_LOGIN`
- `WEBDAV_PASSWORD`

> **Note:** pour utiliser un *remote* webdav, le protocole de l'URL est `webdavs`.
> **Note:** n'oubliez pas d'exporter ces variables.

`npm run build:dev` et `npm start:dev` importent le fichier `.env` quand il existe.

> 📗 Suggestion: déclarez les variables dans le fichier `.env` de cette manière:
>
> ```bash
> export WEBDAV_URL=webdavs://your.webdav.com/dvc
> export WEBDAV_LOGIN=yourlogin
> export WEBDAV_PASSWORD=yourpass
> ```
