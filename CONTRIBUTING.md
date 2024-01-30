# Contributing

Sachant que les contributeurs actuels sont tous francophones, ce fichier sera
écrit en français.

## Récupération du dépôt

Un `git clone` du dépôt est suffisant, mais il est conseillé d'y ajouter un
paramètre supplémentaire, pour distinguer l'ancien dépôt du nouveau:

```bash
git clone git@github.com:Inist-CNRS/web-services.git github-web-services
```

Ainsi, votre répertoire se nommera `github-web-services`, et sera facilement
distingué du répertoire `web-services` correspondant au dépôt `tdm/web-services`
sur le GitBucket de l'Inist.

## Préparation de l'environnement

Les scripts utilisés par ce dépôt sont pour la plupart écrits en node.  
Pour profiter du système des *workspaces*, il faut npm 7+.  
Il faut donc s'assurer d'avoir node 16+ (voir [.nvmrc](.nvmrc)).  

Il est conseillé d'installer node via [nvm](https://github.com/nvm-sh/nvm), et
de se conformer à la version inscrite dans le fichier [.nvmrc](./.nvmrc).  
Pour cela: `nvm install`.  
Pour plus d'information, voir la [documentation de
nvm](https://github.com/nvm-sh/nvm#nvmrc). Il existe même un moyen de passer
automatiquement à la version demandée, en arrivant à la racine du répertoire:
[nvm / Deeper Shell
integration](https://github.com/nvm-sh/nvm#deeper-shell-integration).

## Création d'un service

Avant toute chose, il faut s'assurer qu'un service qui pourrait accueillir votre
nouvelle route n'existe pas déjà. Cela évitera de créer un nouveau service.

### Création du répertoire

Tous les services sont dans le répertoire `services`.  
Chacun dans son propre répertoire.  
Son nom suit la convention de nommage des instances ezmaster: au moins deux
parties composées de lettres minuscules (et éventuellement de chiffres, mais ce
n'est pas conseillé, à cause de la confusion avec le numéro de version de
l'instance). Par exemple :`base-line`, `astro-ner`, ...

Pour profiter du système de *workspaces* de npm, il faut déclarer le répertoire
du nouveau service dans le `package.json` situé à la racine du dépôt.

Par exemple, voici les services `base-line` et `base-line-python` déclarés dans
le `package.json`:

```json
{
  "workspaces": [
    "services/base-line",
    "services/base-line-python"
  ]
}
```

> 📘 Ceci est maintenant automatique quand on utilise le script
> [`generate:service`](SCRIPTS.md#generateservice).

Ainsi, vous serez capable de lancer des scripts d'un service (par exemple
`base-line`) depuis la racine du dépôt (à condition de disposer de npm 7+):

```bash
npm -w services/base-line run start:dev
npm -w services/base-line run stop:dev
```

### Fichiers du service

Chaque répertoire de service contient :

- un répertoire `v1` (ou `v2`, ...) contenant son code source (contenant les
  `.ini`, dans un arbre plus ou moins profond qui détermine les futures routes
  du service).
- un fichier `Dockerfile` qui part d'une image `ezs-python-server`
- un fichier `.dockerignore` (le même que celui de `ezs-python-server`, mais
  dans lequel on ajoute les fichiers sources)
- le cas échéant, un fichier `config.json` contenant la configuration par défaut
  de l'image (quand le service a besoin d'une configuration particulière).
- un fichier `package.json`, sur le modèle de [celui de
  `ezs-python-server`](./bases/ezs-python-server/package.json), où `ezs-python-server`
  est remplacé par le nom du service (celui du répertoire, précédé de `ws-`;
  exemple: `ws-base-line`), et où on réinitialise la version à `0.0.0`.
- un fichier `swagger.json` dans lequel on modifie le title (devant commencer
  par le nom du service, par exemple `base-line -`, c'est ce qui déterminera le
  tri d'affichage des services dans l'OpenAPI).
- un fichier `README.md` expliquant en quoi consiste le service.
- un fichier `examples.http` avec un exemple de requête pour chaque route
- un fichier `tests.hurl` généré à partir des exemples, pour éviter les
  régressions du service

> 📘 Ceci est maintenant automatique quand on utilise le script
> [`generate:service`](SCRIPTS.md#generateservice).

### examples.http

Le fichier `examples.http` se situe à la racine d'une instance (et donc de son
répertoire).

Il contient des exemples de requêtes HTTP, et constitue donc une partie de la
documentation du service.  
Il sert de base à la génération de métadonnées d'exemple en notation pointée
qu'on peut généralement ajouter sans modification dans le `.ini` (via le script
[`generate:example-metadata`](SCRIPTS.md#generateexample-metadata)).  
De plus, il sert aussi à générer les tests (via le script
[`generate:example-tests`](SCRIPTS.md#generateexample-tests)), il est donc
doublement important de bien le renseigner.

Le début du fichier `examples.http` (attention, ce nom est utilisé dans
plusieurs scripts, veillez à bien l'orthographier) contient une commentaire
explicatif, et une variable permettant de changer le serveur cible des requêtes:

```http
# These examples can be used directly in VSCode, using REST Client extension (humao.rest-client)

# Décommenter/commenter les lignes voulues pour tester localement
@host=http://localhost:31976
# @host=https://base-line.services.istex.fr
```

Ensuite viennent les requêtes elles-mêmes.  
Le début d'une requête est signalé par une ligne contenant uniquement `###`.  
Puis, on assigne un identifiant (un `name`) à la requête. Cet identifiant doit
être unique et facile à reconstituer, il est donc conseillé de le construire à
partir de la route de la requête.  
Par exemple, la route `/v1/true/json` donnera lieu à un `name` valant
`v1TrueJson`:

```http
###
# @name v1TrueJson
# On met ici un commentaire décrivant ce que fait la route appelée
```

Après ces commentaires viennent les lignes décrivant la requête:

```http
POST {{host}}/v1/true/json HTTP/1.1
Content-Type: application/json

[
  { "value": "à l'école" },
  { "value": "où" }
]
```

En général on utilise la *méthode HTTP* `POST`, et le `Content-Type:
application/json` (c'est le type du *body* envoyé), puis le tableau JSON envoyé
(et en général, il contient un ou plusieurs objets avec un champ `value`).  

> **Remarque**: comme ces exemples serviront aussi aux tests, il est utile d'y
> mettre aussi des exemples dont on veut vérifier le comportement.

> 📘 Ce fichier est généré automatiquement par le script
> [`generate:service`](SCRIPTS.md#generateservice).  
> Il reste nécessaire d'écrire les requêtes pour chaque route créée.

### tests.hurl

Le fichier `services/<instance>/tests.hurl` est la plupart du temps généré (sauf
pour les enchaînements de services qu'on a dans les `data-*`).

Pour ça, il faut d'abord lancer le serveur en local dans un terminal:

```bash
npm -w services/<instance> run start:dev
```

ou bien

```bash
npx ezs -v -m -d services/<instance>/
```

puis lancer la génération des tests (depuis la racine du dépôt) dans un autre
terminal:

```bash
npm run generate:example-tests services/<instance>
```

> **Remarque**: le fichier `services/<instance>/examples.http` doit exister et
> contenir au moins un exemple.  
> Voir [examples.http](#exampleshttp)

Ce fichier servira lors d'un *push* sur GitHub à tester toutes les routes du
service en question, pour s'assurer de leur non-régression.  
Pour que ce soit utile, toutes les routes doivent être testées.

On peut aussi [tester le serveur local](#tests).

> 📘 On peut aussi écrire ce fichier à la main, voir [hurl](https://hurl.dev/).

### Script d'initialisation d'un nouveau service

Pour faciliter la création d'un nouveau service, un script npm est disponible:
[`generate:service`](SCRIPTS.md#generateservice).

Il prend en paramètre le nom du service (tout en minuscules, en deux parties
séparées par un tiret).  
Il demande le titre du service (*short description*), sa description (*long
description*), le nom de l'auteur et *mail*.  
Il crée le répertoire `services/service-name`, l'ajoute dans les *workspaces* du
dépôt, et dans la liste des services à la fin du [README](./README#services).

> ⚠ Ne pas mettre de caractère `&` dans les réponses, ça provoque un
> remplacement bizarre.

## Développement

### Sans docker

Pour lancer le serveur ezs en dehors de docker:

- se placer à la racine du dépôt
- lancer `npx ezs -v -m -d services/nom-du-service/`

Évidemment, il faut avoir au préalable configuré la bonne version de node (celle
qui correspond aux images de base) et lancé `npm install` depuis la racine du
dépôt.

Il est conseillé d'installer node via [nvm](https://github.com/nvm-sh/nvm), et
de se conformer à la version inscrite dans le fichier [.nvmrc](./.nvmrc).  
Pour cela: `nvm install`.  
Pour plus d'information, voir la [documentation de
nvm](https://github.com/nvm-sh/nvm#nvmrc). Il existe même un moyen de passer
automatiquement à la version demandée, en arrivant à la racine du répertoire:
[nvm / Deeper Shell
integration](https://github.com/nvm-sh/nvm#deeper-shell-integration).

Dans le cas d'un service écrit en python, ne pas oublier d'activer
l'environnement virtuel où sont installées les dépendances (à créer à la racine
du service).

```bash
cd services/<service-name>
# Création de l'environnement virtuel
python3 -m venv .venv
# Activation de l'environnement virtuel
source .venv/bin/activate
```

### Avec docker

Pour construire l'image avec le tag `latest`:

```bash
npm -w services/service-name run build:dev
```

Pour lancer l'image:

```bash
npm -w services/service-name run start:dev
```

Pour arrêter le serveur:

```bash
npm -w services/service-name run stop:dev
```

ou bien:

```bash
docker stop dev
```

## Tests

Pour tester un service lancé localement, utiliser:

```bash
npm run test:local service-name
```

Pour tester un service en production, taper:

```bash
npm run test:remote service-name
```

Pour tester tous les services en production qui ont un fichier
`tests.hurl`:

```bash
npm run test:remotes services/*
```

Pour tester uniquement certains services en production (à condition qu'ils aient
un fichier `tests.hurl`):

```bash
npm run test:remotes service-name service2-name
```

## Ajout dans la liste du README

Une fois que le nouveau service est créé, il faut l'ajouter à la liste du README
de la racine du dépôt.

> 📘 Ceci est automatique quand on utilise le script
> [`generate:service`](SCRIPTS.md#generateservice).

## Les images de base

> ⚠ Cette partie ne concerne pas directement l'écriture des services, mais plus
> le mainteneur des images de base.

Le répertoire `bases` contient les images de base, c'est-à-dire celles qui
simplifient l'écriture de plusieurs services web.

Quand on met à jour les paquets npm de l'image racine `ezs-python-server`, il ne
faut pas oublier de changer les versions des paquets du `package.json` situé à
la racine du dépôt (pour que les serveurs lancés localement utilisent les mêmes
versions que les serveurs sous Docker).

De même, il faut mettre à jour tous les web services qui utilisent ces images de
base! Pour lister les services concernés par une image de base:

```bash
grep ezs-python-server services/*/Dockerfile template/Dockerfile bases/*/Dockerfile
```

Il faut changer le `FROM` de tous les `Dockerfile` trouvés par la commande, et
ne pas oublier de:

1. créer une nouvelle version de l'image de base modifiée:

   ```bash
   cd bases/image-a-modifier
   npm version patch|minor|major
   ```

2. pour chaque `service-name` modifié, lancer:

   ```bash
   npm -w services/service-name version patch
   ```

Il y a plusieurs images de base:

- [`python-node`](./bases/python-node/README.md): image avec python et node,
  base des serveurs ezs
- [`ezs-python-server`](./bases/ezs-python-server/README.md): serveur ezs vide,
  acceptant les scripts ezs et python
- [`ezs-python-saxon-server`](./bases/ezs-python-saxon-server/README.md):
  serveur ezs vide, acceptant les scripts ezs et python, embarquant saxon, sous
  la forme de la commande `xslt`.

## Nouvelle branche

La branche principale (`main`) du dépôt est protégée.  
Ça signifie que pour contribuer au dépôt, il faut passer par le mécanisme des
*pull requests*.  

Et pour créer une *pull request* (ou contribution), il faut d'abord créer une branche.  

Son nom est important, car il permettra aux *GitHub Actions* automatiques
d'obtenir des informations sur la partie du dépôt qui est travaillée.  

Les noms des branches auront 3 parties:

1. `services` pour indiquer qu'on travaille dans le répertoire des services
2. le nom du service (ou de l'image de base) concerné(e) (en deux parties
   séparées par un tiret, suivant la convention de nommage des *containers* dans
   [ezmaster](https://github.com/Inist-CNRS/ezmaster)), correspondant au nom du
   répertoire (donc sans `ws-`)
3. le détail de l'opération. C'est un commentaire (où il faut séparer les mots
   par des tirets)

Chacune de ces parties sera écrite en minuscules, sans accent, sans espace, et
elles seront séparées par le caractère `/`.

Par exemple, pour améliorer le service `base-line`, et lui ajouter une route
`v1/lowercase`, on pourrait créer une branche nommée
`services/base-line/add-route-lowercase`.

Ainsi, c'est le service `base-line` qui sera concerné par les actions
automatiques.  

D'autres exemples de noms de branche:

- `services/base-line-python/make-python-script-executable`
- `services/base-line/change-required-input-for-no-accent`
- `services/terms-teeft/add-teeft-with-number`
- `docs/contributing/add-new-branch`

> **Remarque** : seules branches commençant par `services/` et contenant deux
> `/` déclencheront l'action de test du service.

> **Remarque** : comme nous construisons des programmes *open source*, tâchons
> de garder tout ce qui est technique (ça peut exclure la documentation
> elle-même) en anglais.

## Création d'une version

Une version se crée manuellement. Pour ça il faut se déplacer dans le
répertoire du `Dockerfile` et lancer `npm version` en utilisant l'argument
`major`, `minor` ou `patch` suivant qu'il y a un changement majeur, un ajout de
fonctionnalité ou une correction.

Cela va créer un tag, modifier le numéro de version dans le README, et pousser
le tout sur GitHub, déclenchant une action de Github qui poussera
automatiquement l'image sur Docker Hub.

> **Remarque**: on peut aussi utiliser l'option *workspace* `-w` de npm pour
> créer la version depuis la racine du dépôt: `npm version -w
> services/service-name patch`.

## Mise en production

Pour la mise en production d'un service, il faut modifier son fichier
`swagger.json`.  

Il faut transformer cette partie:

```json
    "servers": [
        {
            "x-comment": "Will be automatically completed by the ezs server."
        },
        {
            "url": "http://vptdmservices.intra.inist.fr:49233/",
            "description": "Latest version for production",
            "#DISABLED#x-profil": "Standard"
        }
    ],
```

en

```json
    "servers": [
        {
            "x-comment": "Will be automatically completed by the ezs server."
        },
        {
            "url": "http://vptdmservices.intra.inist.fr:49245/",
            "description": "Latest version for production",
            "x-profil": "Standard"
        }
    ],
```

Où:

1. on enlève `#DISABLED#` devant `x-profil`, en vérifiant que la valeur de ce
   champ est bien `Standard`,
2. on ajuste le champ `url` du même objet pour pointer sur l'URL interne du
   container sur la machine de production.

> ⚠ Pendant la phase de transition du code source des services web, on publiera
> les services en production à partir du dépôt
> [GitBucket](https://gitbucket.inist.fr/tdm/web-services) où la procédure est
> la même, mais où on supprimera tous les fichiers du services, excepté
> `swagger.json`, qui contiendra les mêmes valeurs que sur GitHub.

Puis, on lance `./bin/publish`, qui demande les *login* et mot de passe de la
machine du *reverse proxy*.

> Le script `./bin/publish` à utiliser pendant la phase de transition est celui
> du GitBucket.
