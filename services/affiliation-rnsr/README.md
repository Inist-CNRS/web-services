# ws-affiliation-rnsr@3.0.3

Trouve un RNSR à partir d'une affiliation.

Pour chaque affiliation séparées par un point virgule, retourne un RNSR. Retourne n/a si aucun RNSR n'est trouvé.

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
