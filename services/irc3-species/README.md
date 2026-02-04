# ws-irc3-species@1.1.9

IRC3 dédiée à la recherche des noms scientifiques

IRC3sp est une version de l’outil IRC3 dédiée à la recherche des noms
scientifiques — ou noms binominaux — d’espèces animales, végétales ou autres
dans un corpus de textes en se référant à une liste finie (mais, aussi
exhaustive que possible).

## Configuration

### Variables d'environnement

#### `IRC3SP_DEBUG`

- **Type** : `boolean`
- **Valeur par défaut** : `false`
- **Description** : Active l'affichage des messages de progression et de debug sur stderr.

Lorsque `IRC3SP_DEBUG` est défini à `true`, le script affiche :

- Le chargement de la ressource
- Le nombre de termes dans la liste
- La progression du traitement
- Les termes refusés
- Les avertissements d'ambiguïté
- Les erreurs de traitement

**Exemple dans `config.json`** :

```json
{
    "environnement": {
        "IRC3SP_DEBUG": true
    }
}
```

#### `IRC3SP_LOG`

- **Type** : `string` (chemin de fichier) ou `false`
- **Valeur par défaut** : `false`
- **Description** : Active l'écriture des statistiques et avertissements dans un fichier de log.

Lorsque `IRC3SP_LOG` est défini avec un chemin de fichier, le script écrit dans ce fichier :

- Les doublons détectés dans la table de ressources
- Les avertissements d'ambiguïté sur les formes non abrégées
- Les statistiques de traitement (nombre de références, occurrences, identifiant)

**Exemple dans `config.json`** :

```json
{
    "environnement": {
        "IRC3SP_LOG": "/tmp/irc3sp.log"
    }
}
```

Pour désactiver le logging, définir `IRC3SP_LOG` à `false` ou ne pas définir la variable.
