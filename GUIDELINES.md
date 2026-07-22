# Web Services TDM - ISTEX: quelques directives

Ce document établit les principes directeurs à respecter lors de la création de
web services de TDM au sein de l'infrastructure ISTEX portée par l'Inist-CNRS.
Il s'adresse aux créateurs de web services et non pas aux utilisateurs.

## Atomicité des services

**Un web service doit être atomique**: il répond à **un seul besoin** et
effectue **une seule tâche** bien définie.

Cette approche facilite:

- la maintenance et l'évolution indépendante de chaque service,
- la réutilisabilité dans différents contextes,
- le débogage et l'identification des problèmes,
- la composition de pipelines de traitement complexes,
- la légèreté du service.

### Exemples

- ✔ un service d'extraction de termes
- ✔ un service de détection d'entités nommées
- ✖ un service qui extrait les termes *et* fait de la classification

## Unicité fonctionnelle

**On ne peut pas avoir plusieurs web services qui effectuent exactement la même
tâche**.

Cela mettrait l'utilisateur devant un choix difficile à faire.  
Cependant, un web service peut être :

- **amélioré** : nouvelles versions avec optimisations ou corrections,
- **remplacé** : par un autre web service plus performant utilisant une approche diférente.

Dans ce cas, l'ancien service peut être maintenu en parallèle pendant une
période de transition, puis déprécié.

## Nommage

Le nom du web service doit être en anglais, au singulier (sauf exception), sous la forme :

- objetTraitéTraitement ou objetTraitéAction
- abréviation de l'objetTraité et/ou du traitement si nom trop long (quantiDetect)

Il doit être en camelCase : écrire un ensemble de mots en les liant sans espace
ni ponctuation, et en mettant en capitale la première lettre de chaque moit sauf
celle du premier mot qui doit être en minuscule. Il ne doit pas y avoir de
nombre, de caractère accentué, d'espace, de caractères spéciaux. Des exceptions
sont possibles, notamment dans le cas où le web service est une mise en
production d'un service connu (par exemple Grobid ou Termsuite).

## Formats d'entrée/sortie

Les données en entrée/sortie doivent être au format standard JSON « id / value ».  
**Le service doit accepter et retourner du JSON sous la forme:**

| Entrée - JSON                      | Sortie - JSON |
| ---------------------------------- | ------------- |
| `[`                                | `[`           |
| ` {`                               | ` {`          |
| `  "id": "identifiant-unique"`,    | `  "id": "identifiant-unique"`, |
| `  "value": ["contenu à traiter"]`,| `  "value": ["résultat","du","traitement"]`, |
| ` }`                               | ` }`          |
| `]`                                | `]`           |

### Variations acceptables

- le champ `value` en sortie peut contenir des objets complexes selon le besoin,
- des champs additionnels peuvent être ajoutés (ex: métadonnées, scores), mais
  ils doivent alors être à l'intérieur de l'objet `value`,
- le champ `id` doit toujours être préservé pour permettre le chaînage de
  traitements.

### Exemple (extraction de termes)

```json
[
    {
        "id": "doc123",
        "value": [
            { "term": "intelligence artificielle", "frequency": 12, "specificity": 0.85 },
            { "term": "apprentissage automatique", "frequency": 8, "specificity": 0.72 }
        ]
    }
]
```

> [!NOTE] 
> Le squelette ezs envoie chaque objet du flux en entrée sous forme d'objets
  JSON, ligne par ligne, de sorte que quand c'est un programme python qui traite
  le flux, il devrait recevoir un objet JSON par ligne.

## Conteneurisation

**Tout service doit etre dockerisé.**  

**Optimisation de la taille :**

- la taille du container doit être la plus petite possible,
- **limite maximale recommandée :** environ 3Gio (décompressée, soit environ
  1Gio compressée).

**Bonnes pratiques :**

**Utiliser les images de base officielles** fournies par l'infrastructure :

- `cnrsinist/ezs-python-server` pour les services Python et Node.js,
- `cnrsinist/ezs-python-pytorch-server` pour les services utilisant PyTorch,
- `cnrsinist/ezs-python-saxon-server` pour les services utilisant XSLT.

## Dépôt des ressources nécessaires sur DVC

Les ressources nécessaires à l'exécution d'un web service doivent être déposées
dans DVC installé à l'Inist. DVC est un outil de versionnage de données,
lorsqu'on crée un service qui nécessite un modèle ou une table, il est
nécessaire de l'utiliser pour ne pas avoir de gros fichiers sur git et pour des
raisons de sécurité.  
Les modèles, les tables, et autres ressources ne doivent pas apparaître dans le
dépôt GitHub.

## Compatibilité avec l'infrastructure serveur

**Le web service doit fonctionner sur les serveurs mis à disposition par
l'Inist.**

Machines virtuelles sans GPU, sous Ubuntu (16.04/18.04). Actuellement 16 à 32
cœurs, 64 à 96 Gio de RAM selon la VM.  
Ces caractéristiques sont valables à la date du 15/06/2026, se renseigner sur
les caractéristiques actuelles.  

## Performance et scalabilité

**Le web service doit être capable de passer à l'échelle.**

**Contexte :** les analyses utiilisent couramment des corpus de plusieurs
dizaines de milliers de documents.

**Traitement par flux (streaming) :**

- le service doit traiter les données en flux continu,
- ne pas charger l'intégralité du corpus en mémoire,
- **temps de réponse :** varie selon le traitement et le document. Pour les
  services synchrones, le temps de réponse doit rester sous 60 secondes
  (*timeout* réseeau). Au-delà, le service doit être asynchrone.

## Qualité et évaluation

**Un web service ne passe en production que si son résultat a été évalué et
qu'il atteint ou dépasse les critères de qualité du domaine.**

1. **Dataset d'évaluation :**

  - constituer ou utiliser un dataset de référence représentatif,
  - le dataset doit contenir des exemples variés et des *edge cases*,
  - **le dataset utilisé pour l'évaluation sera mis à disposition avec le web service.**

2. **Métriques de qualité :**

  - définir les métriques appropriées selon le type de service : les seuils
    minimaux acceptabes pour chaque métrique doivent correspondre aux standards
    du domaine scientifique.

## Documentation

Chaque service doit **obligatoirement** fournir une documentation :

a. **fiche descriptive sur services.istex.fr :**

Cette fiche décrit le web service pour les utilisateurs, elle est **obligatoire**:

- sur le modèle des fiches existantes,
- décrit le service, son mode de fonctionnement, ses cas d'usagen ses performances,
- lien vers le dépôt GitHub, l'OpenAPI/Swagger et la documentation.

b. **swagger.json** (OpenAPI 3.0) :

- documentation complète de l'API,
- schémas de requêtes et réponses,
- exemples pour chaque *endpoint*,
- généré automatiquement à partir des fichiers `.ini`.

c. **examples.http** :

- exemples d'utilisation réels avec REST CLient (VSCode),
- couvre tous les cas d'usage principaux,
- sert de base pour générer les tests `hurl` (et les exemples du swagger).

d. **documentation additionnelle si nécessaire**

`swagger.md` qui permet d'intégrer facilement au `swagger.json`:

- guides d'utilisation avancés,
- documentation des algorithmes,
- références bibliographiques.

## Gestion des erreurs

**Le web service doit gérer les erreurs de manière robuste.**

a. **Validation des entrées :**

- vérifier la structure JSON,
- valider les champs requis (`id`, `value`), par exemple en utilisant [validate](https://inist-cnrs.github.io/ezs/#/plugin-core?id=validate) dans le script ezs,
- retourner des erreurs 400 (*Bad Request*) explicites.

b. **Gestion des erreurs de traitement :**

- capturer toutes les exceptions,
- logger les erreurs pour le débogage,
- ne pas faire échouer l'ensemble du traitement pour une erreur sur un document,
- retourner un résultat partiel ou un indicateur d'erreur pour le document
  problématique (dans le champ `value`).

c. **Codes de statut HTTP appropriés :**

- 200 (*OK*) traitment réussi,
- 400 (*Bad Request*) erreurs dans la requête,
- 500 (*Internal Server Error*) erreur serveur (gérée par ezs),
- 503 (*Service Unavailable*) service temporairement indisponible (géré ailleurs).

d. **Messages d'erreur informatifs :**

- messages clairs et exploitables,
- inclure le contexte `id` du document (si applicable),
- ne pas exposer d'information sensible.

## Maintenance

- maintenir le service fonctionnel,
- corriger les bugs signalés,
- mettre à jour les dépendances,
- répondre aux questions des utilisateurs.

## Compatibilité Lodex / TDM Factory

Le service doit être fonctionnel dans Lodex, sauf exception justifiée. Dans le
cas où il ne serait pas compatible Lodex il doit être compatible TDM Factory.
