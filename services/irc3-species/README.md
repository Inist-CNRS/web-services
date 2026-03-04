# ws-irc3-species@1.1.9

IRC3 dédiée à la recherche des noms scientifiques

IRC3sp est une version de l’outil IRC3 dédiée à la recherche des noms
scientifiques — ou noms binominaux — d’espèces animales, végétales ou autres
dans un corpus de textes en se référant à une liste finie (mais, aussi
exhaustive que possible).

## Nom binominal

Pour mémoire, en taxonomie, un nom binominal est formé de deux noms latins (ou
latinisés) comprenant le nom de genre et le nom spécifique, comme “*Canis
lupus*” pour le loup. Ce nom est normalement écrit en italique avec une initiale
en majuscule pour le nom de genre et il peut être présent sous une forme abrégée
où seule l'initiale du nom de genre est indiquée, comme “*C. lupus*”. À
l'exception d'espèces très connues comme *Escherichia coli* qui est souvent
simplement écrit *E. coli*, la forme abrégée ne doit être utilisée que si la
forme longue est déjà apparue au moins une fois. De plus, si un nom de genre a
été cité, toutes les espèces appartenant à ce même genre peuvent ensuite être
citées sous forme abrégée, comme “*Canis lupus*, *C. latrans* et *C. aureus*”
(pour “*Canis lupus*, *Canis latrans* et *Canis aureus*”).

Cependant, les formes abrégées peuvent être ambigües. Par exemples, on a deux
espèces de poissons, *Cyprinus carpio* et *Carpiodes carpio*, qui ont la même
abréviation : *C. carpio*. Pour éviter les erreurs, **IRC3sp** commence par
faire la liste des noms de genre présents dans le document analysé pour obtenir
l'ensemble des espèces correspondantes dans la ressource, et donc, l’ensemble
des abréviations possibles. Malgré cela, si une ambigüité demeure, on considère
comme valide le dernier nom de genre cité *in extenso* avant l'occurrence de la
forme abrégée.

## Configuration

### Options de ligne de commande

```txt
    -c  tient compte de la casse (majuscule/minuscule) des termes recherchés
    -t  indique le nom du fichier contenant la ressource, c'est-à-dire la liste
        des termes à rechercher
```

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
