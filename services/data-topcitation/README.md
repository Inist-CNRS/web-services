# ws-data-topcitation@3.0.0

Référence phare d'un corpus

A partir d'une liste de doi renvoie les 10 références les plus citées.
Utilise l'API OpenAlex pour récupérer les données de citations.

À noter: à la mise en production, il faut ajouter la clé `OPENALEX_API_KEY` dans l'environnement. Quand on utilise ezMaster, c'est en
modifiant la configuration du container.

Pour le développement: mettez cette variable d'environnement dans le fichier
`.env` du répertoire du service, sous la forme:

```sh
export OPENALEX_API_KEY=LA_CLE_API
```