# ws-biblio-ref@3.0.1

Valide une référence bibliographique

Si un DOI est trouvé dans la référence bibliographique, valide la référence et indique si elle est rétractée

## Construction de l'image docker

Nécessite une variable d'environnement `CROSSREF_API_KEY`, un token pour utiliser l'API Crossref. Elle doit se trouver dans un un fichier `.env` à la racine (voir le fichier .env.example associé).
Si vous ne disposez pas de token, vous pouvez supprimer les  headers des requêtes Crossref dans l'ensemble des fonctions python définies dans le fichier `./v1/bibref/bibref_functions.py`. Il faudra également supprimer les paramètres `--env-file .env` des scripts `npm start:dev` et `npm start` du `package.json`. Vous pouvez également utiliser la version 2.0.1.
