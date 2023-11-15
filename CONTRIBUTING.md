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

## Création d'un service

### Création du répertoire

Tous les services sont dans le répertoire `services`.  
Chacun dans son propre répertoire.  
Son nom suit la convention de nommage des instances ezmaster: au moins deux
parties composées de lettres minuscules (et éventuellement de chiffres, mais ce
n'est pas conseillé, à cause de la confusion avec le numéro de version de
l'instance). Par exemple :`base-line`, `astro-ner`, ...

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
  exemple: `ws-base-line`), et où on réinitialise la version à `1.0.0`.
- un fichier `swagger.json` dans lequel on modifie le title (devant commencer
  par le nom du service, par exemple `base-line -`, c'est ce qui déterminera le
  tri d'affichage des services dans l'OpenAPI).
- un fichier `README.md` expliquant en quoi consiste le service.
- un fichier `examples.http` avec un exemple de requête pour chaque route
- un fichier `tests.hurl` généré à partir des exemples, pour éviter les
  régressions du service

### Développement

#### Sans docker

Pour lancer le serveur ezs en dehors de docker:

- se placer à la racine du dépôt
- lancer `npx ezs -v -d services/nom-du-service/`

Évidemment, il faut avoir au préalable lancé `npm install` depuis la racine du
dépôt.

Dans le cas d'un service écrit en python, ne pas oublier d'activer
l'environnement virtuel où sont installées les dépendances.

#### Avec docker

Pour construire l'image avec le tag `latest`:

```bash
npm run build:dev
```

Pour lancer l'image:

```bash
npm run start:dev
```

Pour arrêter le serveur: Contrôle-C.

### Ajout dans la liste du README

Une fois que le nouveau service est créé, il faut l'ajouter à la liste du README
de la racine du dépôt.

### Création d'une version

Se déplacer dans le répertoire du `Dockerfile` et lancer `npm version` en
utilisant l'argument `major`, `minor` ou `patch` suivant qu'il y a un changement
majeur, un ajout de fonctionnalité ou une correction.

Cela va créer un tag, modifier le numéro de version dans le README, et pousser
le tout à la fois sur GitHub et sur Docker Hub.

### Les images de base

Le répertoire `bases` contient les images de base, c'est-à-dire celles qui
simplifie l'écriture de plusieurs services web.

Quand on met à jour les paquets npm de l'image racine `ezs-python-server`, il ne
faut pas oublier de changer les versions des paquets du `package.json` situé à
la racine du dépôt (pour que les serveurs lancés localement utilisent les mêmes
versions que les serveurs sous Docker).
