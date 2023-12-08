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
- deux fichiers `local-tests.hurl` et `remote-tests.hurl` générés à partir des
  exemples, pour éviter les régressions du service

### examples.http

Le fichier `examples.http` se situe à la racine d'une instance (et donc de son
répertoire).

Il contient des exemples de requêtes HTTP, et constitue donc une partie de la
documentation du service.  
Il sert de base à la génération de métadonnées d'exemple en notation pointée
qu'on peut généralement ajouter sans modification dans le `.ini`.  
De plus, il sert aussi à générer les tests, il est donc doublement important de
bien le renseigner.

Le début du fichier `examples.http` (attention, ce nom est utilisé dans
plusieurs scripts, veillez à bien l'orthographier) contient une commentaire
explicatif, et une variable permettant de changer le serveur cible des requêtes:

```http
# These examples can be used directly in VSCode, using REST Client extension (humao.rest-client)

# Décommenter/commenter les lignes voulues pour tester localement
@baseUrl=http://localhost:31976
# @baseUrl=https://base-line.services.istex.fr
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
POST {{baseUrl}}/v1/true/json HTTP/1.1
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

## local-tests.hurl et remote-tests.hurl

Les fichiers `services/<instance>/local-tests.hurl` et
`services/<instance>/remote-tests.hurl` sont la plupart du temps générés (sauf
pour les enchaînements de services qu'on a dans les `data-*`).

Pour ça, il faut d'abord lancer le serveur en local dans un terminal:

```bash
cd services/<instance>
npm run start:dev
```

ou bien

```bash
npx ezs -v -d services/<instance>/
```

puis lancer la génération des tests (depuis la racine du dépôt) dans un autre
terminal:

```bash
npm run generate:example-tests services/<instance>
```

> **Remarque**: le fichier `services/<instance>/examples.http` doit exister et
> contenir au moins un exemple.  
> Voir [examples.http](#exampleshttp)

## Développement

### Sans docker

Pour lancer le serveur ezs en dehors de docker:

- se placer à la racine du dépôt
- lancer `npx ezs -v -d services/nom-du-service/`

Évidemment, il faut avoir au préalable lancé `npm install` depuis la racine du
dépôt.

Dans le cas d'un service écrit en python, ne pas oublier d'activer
l'environnement virtuel où sont installées les dépendances.

### Avec docker

Pour construire l'image avec le tag `latest`:

```bash
npm run build:dev
```

Pour lancer l'image:

```bash
npm run start:dev
```

Pour arrêter le serveur:

```bash
npm run stop:dev
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
`remote-tests.hurl`:

```bash
npm run test:remotes services/*
```

Pour tester uniquement certains services en production (à condition qu'ils aient
un fichier `remote-tests.hurl`):

```bash
npm run test:remotes service-name service2-name
```

## Ajout dans la liste du README

Une fois que le nouveau service est créé, il faut l'ajouter à la liste du README
de la racine du dépôt.

## Les images de base

Le répertoire `bases` contient les images de base, c'est-à-dire celles qui
simplifient l'écriture de plusieurs services web.

Quand on met à jour les paquets npm de l'image racine `ezs-python-server`, il ne
faut pas oublier de changer les versions des paquets du `package.json` situé à
la racine du dépôt (pour que les serveurs lancés localement utilisent les mêmes
versions que les serveurs sous Docker).

Il y a plusieurs images de base:

- [`python-node`](./bases/python-node/README.md): image avec python et node,
  base des serveurs ezs
- [`ezs-python-server`](./bases/ezs-python-server/README.md): serveur ezs vide,
  acceptant les scripts ezs et python

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
le tout sur GitHub, déclenachant une action de Github qui poussera
automatiquement l'image sur Docker Hub.
