# ws-biblio-ref@3.2.0

Valide une référence bibliographique

Si un DOI est trouvé dans la référence bibliographique, valide la référence et indique si elle est rétractée

## Construction de l'image docker

Nécessite une variable d'environnement `CROSSREF_API_KEY`, un token pour utiliser l'API Crossref. Elle doit se trouver dans un un fichier `.env` à la racine (voir le fichier .env.example associé).
Si vous ne disposez pas de token, vous pouvez supprimer les  headers des requêtes Crossref dans l'ensemble des fonctions python définies dans le fichier `./v1/bibref/bibref_functions.py`. Il faudra également supprimer les paramètres `--env-file .env` des scripts `npm start:dev` et `npm start` du `package.json`. Vous pouvez également utiliser la version 2.0.1.

## Télécharger le PPS en local

Pour les tests en local, il peut être contraignant de télécharger le contenu du PPS à chaque build. Nous pouvons donc supprimer temporairement le [télchargement du dockerfile](https://github.com/Inist-CNRS/web-services/blob/b68b9b50f9fe17caeb8182c86b15fa624108397d/services/biblio-ref/Dockerfile#L20) et exploiter le résultat directement en local. Pour l'obtenir une fois "pour toute" en local, voici la commande (cas où le dépôt git `web-services` est clôné dans `~/workspace`):

```sh
curl -go /tmp/pps.csv 'https://dbrech.irit.fr/pls/apex/f?p=9999:300::IR[allproblematicpapers]_CSV' && \
awk -F '","' 'index($1,"annulled") {print $2}' /tmp/pps.csv > ~/workspace/web-services/services/biblio-ref/v1/annulled.csv && \
rm /tmp/pps.csv && \
python ~/workspace/web-services/services/biblio-ref/v1/csv2pickle.py ~/workspace/web-services/services/biblio-ref/v1/annulled.csv && \
rm ~/workspace/web-services/services/biblio-ref/v1/annulled.csv
```

Ne pas push ce fichier en l'état sur GIT, le fichier peut ainsi se mettre à jour à chaque version.
