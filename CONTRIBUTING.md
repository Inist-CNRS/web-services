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
Il faut donc s'assurer d'avoir node 22+ (voir [.nvmrc](.nvmrc)).  

Il est conseillé d'installer node via [nvm](https://github.com/nvm-sh/nvm), et
de se conformer à la version inscrite dans le fichier [.nvmrc](./.nvmrc).  
Pour cela: `nvm install`.  
Pour plus d'information, voir la [documentation de
nvm](https://github.com/nvm-sh/nvm#nvmrc). Il existe même un moyen de passer
automatiquement à la version demandée, en arrivant à la racine du répertoire:
[nvm / Deeper Shell
integration](https://github.com/nvm-sh/nvm#deeper-shell-integration).

Pour VSCode, il est recommandé d'accepter l'installation des extensions:

- [EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)
- [markdownlint](https://marketplace.visualstudio.com/items?itemName=davidanson.vscode-markdownlint)

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

## Création d'un service

Avant toute chose, il faut s'assurer qu'un service qui pourrait accueillir votre
nouvelle route n'existe pas déjà. Cela évitera de créer un nouveau service.

À noter: les sous-sections suivantes expliquent la structure du répertoire à
 créer pour un service, mais le script
 [`generate:service`](SCRIPTS.md#generateservice) se charge maintenant
 d'initialiser le répertoire pour vous. Voir [Script d'initialisation d'un
 nouveau service](#script-dinitialisation-dun-nouveau-service)

### Création du répertoire

> 📘 Ceci est maintenant automatique quand on utilise le script
> [`generate:service`](SCRIPTS.md#generateservice).
> Voir [Script d'initialisation d'un nouveau service](#script-dinitialisation-dun-nouveau-service)

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

Ainsi, vous serez capable de lancer des scripts d'un service (par exemple
`base-line`) depuis la racine du dépôt (à condition de disposer de npm 7+):

```bash
npm -w services/base-line run start:dev
npm -w services/base-line run stop:dev
```

### Fichiers du service

> 📘 Ceci est maintenant automatique quand on utilise le script
> [`generate:service`](SCRIPTS.md#generateservice).

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

### examples.http

Le fichier `examples.http` se situe à la racine d'une instance (et donc de son
répertoire).

> 📘 Ce fichier est initialisé automatiquement par le script
> [`generate:service`](SCRIPTS.md#generateservice).  
> Il reste nécessaire d'écrire les requêtes pour chaque route créée.

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

> [!TIP]  
> Lorsque le test ne passe pas sur GitHub, parce que la route en question
> utilise une API vérifiant l'IP de l'appelant, on peut se contenter de
> désactiver ce test en fonction d'une variable `blocked` (qui sera
> automatiquement positionnée à `true` sur GitHub).  
>
> ```ini
> [Options]
> skip: {{blocked}}
> ```

### Script d'initialisation d'un nouveau service

Pour faciliter la création d'un nouveau service, un script npm est disponible:
[`generate:service`](SCRIPTS.md#generateservice).

Il prend en paramètre le nom du service (tout en minuscules, en deux parties
séparées par un tiret).  
Il demande le titre du service (*short description*), sa description (*long
description*), le nom de l'auteur et *mail*.  
Il crée le répertoire `services/service-name`, l'ajoute dans les *workspaces* du
dépôt, et dans la liste des services à la fin du [README](./README#services).

Exemple:

```bash
npm run generate:service service-name
```

> ⚠ Ne pas mettre de caractère `&` dans les réponses, ça provoque un
> remplacement bizarre.

### OpenAPI: ajout d'une description multi-lignes dans les métadonnées du .ini

Pour avoir une documentation OpenAPI complète, on peut écrire la description
d'un service en Markdown.  
On peut se contenter d'écrire cette description dans la métadonnée
`post.description` directement, en mettant les lignes bout-à-bout, séparées par
`^M`.  
Mais il est plus simple d'utiliser le script `./bin/insert-description.sh`, qui
prend en paramètres un ou plusieurs chemins de fichiers Markdown (`.md`).  
Pour chaque fichier `.md`, il insère le contenu dans le fichier dont le chemin
correspond au nom du `.md` (en remplaçant les `_` par des `/`).  

Exemples:

```bash
./bin/insert-description.sh services/terms-extraction/v1*.md
./bin/insert-description.sh services/terms-extraction/v1_teeft_fr.md
```

Alternative: utiliser le script npm `insert:description`:

```bash
$ npm run insert:description services/terms-extraction/v*.md

> web-services@1.0.0 insert:description
> ./bin/insert-description.sh services/terms-extraction/v1_teeft_en.md services/terms-extraction/v1_teeft_fr.md services/terms-extraction/v1_teeft_with-numbers_en.md services/terms-extraction/v1_teeft_with-numbers_fr.md

 - services/terms-extraction/v1/teeft/en.ini ✓
 - services/terms-extraction/v1/teeft/fr.ini ✓
 - services/terms-extraction/v1/teeft/with-numbers/en.ini ✓
 - services/terms-extraction/v1/teeft/with-numbers/fr.ini ✓
```

> **Note**: si vous voulez bénéficier de l'auto-complétion des chemins de
> fichiers, utilisez plutôt `./bin/insert-description.sh`.

### Utilisation de DVC (pour charger des données ou des modèles)

[DVC](https://dvc.org/) est un outil de versionnage de données. Lorsqu'on crée un service qui nécessite un modèle ou une table, il est nécessaire de l'utiliser pour ne pas avoir de gros fichiers sur git.
En plus du reste, il faut suivre ces étapes lorsqu'on utilise DVC :

- S'assurer d'avoir déposé les données sur le webdav du service TDM en ayant préalablement utilisé DVC (pour cela : )
  - mettre son fichier nommé `DOSSIER_OU_FICHIER_A_PUSH` dans un autre dossier.
  - Initier un dépôt DVC en faisant `dvc init` (nécessite d'être dans un dépôt git).
  - se connecter au webdav du service (à ne faire que la première fois), pour cela :
    - spécifier l'url du webdav (en utilisant le protocole webdavs): `dvc remote add -d webdav-remote webdavs://YOUR_WEBDAV_URL.fr`
    - entrer le login : `dvc remote modify --local webdav-remote login YOUR_LOGIN`
    - entrer le mot de passe : `dvc remote modify --local webdav-remote password YOUR_PASSWORD`
  - push le fichier sur le webdav : `dvc add DOSSIER_OU_FICHIER_A_PUSH` puis `dvc push`, sans se soucier du nom
  - Le fichier `DOSSIER_OU_FICHIER_A_PUSH.dvc` est créé et devra être copié à l'endroit où le modèle doit être dans le code
  - ***remarque** : il est possible de faire tout ça dans le dépôt git directement, cela ajoutera simplement un `.gitignore` qu'il ne faudra pas déplacer ou supprimer. Aussi, les dossiers `.dvc` et `.dvcignore` ne seront ni à ignorer par git, ni a push sur le dépôt*
- Créer un fichier `.env` à la racine **du service** (`./services/\<service-name\>/.env`) qui ressemblera à ça :

  ```bash
  export WEBDAV_URL=webdavs://YOUR_WEBDAV_URL.fr
  export WEBDAV_LOGIN=YOUR_LOGIN
  export WEBDAV_PASSWORD=YOUR_PASSWORD 
  ```

- modifier les scripts `build:dev` et `build` du fichier `package.json` du service
  - pour `build:dev` :

    ```txt
    ". ./.env 2> /dev/null; DOCKER_BUILDKIT=1 docker build -t cnrsinist/${npm_package_name}:latest --secret id=webdav_login,env=WEBDAV_LOGIN --secret id=webdav_password,env=WEBDAV_PASSWORD --secret id=webdav_url,env=WEBDAV_URL ." 
    ```

  - pour `build`:

    ```txt
     ". ./.env 2> /dev/null; DOCKER_BUILDKIT=1 docker build -t cnrsinist/${npm_package_name}:${npm_package_version} --secret id=webdav_login,env=WEBDAV_LOGIN --secret id=webdav_password,env=WEBDAV_PASSWORD --secret id=webdav_url,env=WEBDAV_URL ."
     ```

- modifier le `Dockerfile` en conséquence, en s'inspirant du [Dockerfile de `affiliation-rnsr`](https://github.com/Inist-CNRS/web-services/blob/main/services/affiliation-rnsr/Dockerfile)
- arrêter le conteneur.
- reconstruire l'image :

    ```bash
    npm -w services/service-name run build:dev
    ```

- relancer le conteneur

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
HURL_blocked=false npm run test:local service-name
```

Pour tester un service en production, taper:

```bash
HURL_blocked=false npm run test:remote service-name
```

Pour tester tous les services en production qui ont un fichier
`tests.hurl`:

```bash
HURL_blocked=false npm run test:remotes services/*
```

Pour tester uniquement certains services en production (à condition qu'ils aient
un fichier `tests.hurl`):

```bash
HURL_blocked=false npm run test:remotes service-name service2-name
```

> 📘 Pour éviter qu'un service soit testé lorsqu'il est en production, on peut
> positionner la propriété `avoid-testing` du `package.json` du service à
> `true`.
>
> Exemple de cas où c'est utile: `ark-tools`, où on crée des identifiants censés
> être uniques. Afin de ne pas épuiser les possibilités, on évite de le tester
> trop souvent.

Pour tester un service qui est sur une machine de production, mais pas encore
publié (sans URL externe), en se basant sur l'URL présente dans `swagger.json`
(et en remplaçant le nom de la machine par son IP interne, si on la connaît):

```bash
./bin/test-ip-services.sh services/service-name/
```

> [!IMPORTANT]  
> La partie `HURL_blocked=false` permet de préciser qu'on veut lancer *tous* les
> tests du fichier `tests.hurl` concerné.  
> Cette variable d'environnement est là pour permettre de lancer les tests d'un
> fichier `tests.hurl` tout en ignorant ceux qui nécessitent un accès aux
> services ISTEX.  
> C'est le cas quand un GitHub Action essaye de lancer les tests: son IP n'est
> pas présente dans les IP autorisées à accéder aux services ISTEX en
> production.  
> Dans ce cas, ou quand l'ordinateur depuis lequel on veut lancer les tests n'a
> pas d'IP autorisée (par exemple chez soi, sans le VPN), on doit positionner la
> variable `HURL_blocked` à `true`.  

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

> **Note:** il existe maintenant un script qui se charge de la mise à jour des
> images qui dépendent directement d'une image de base: [`npm run update:images
> <image-name>`](./SCRIPTS.md#updateimages).  Assurez-vous que l'image a été créée (version, build, push)
> avant de lancer le script.

## Création d'une version

Pour créer une version, on peut se servir de npm et du *workspace* associé au service en question.  
Exemple: `npm -w services/service-nme version patch`.  
L'argument de `npm version` est `major`, `minor` ou `patch` suivant qu'il y a un
changement majeur, un ajout de fonctionnalité ou une correction.  

Cela va créer un tag, modifier le numéro de version dans le README, et pousser
le tout sur GitHub, déclenchant une action de Github qui poussera
automatiquement l'image sur Docker Hub.

> **Remarque**: on peut aussi créer la version manuellement. Pour ça il faut se déplacer dans le
répertoire du `Dockerfile` et lancer `npm version` en utilisant l'argument
`major`, `minor` ou `patch` suivant qu'il y a un changement majeur, un ajout de
fonctionnalité ou une correction.

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

Puis, on lance `./bin/publish.sh`, qui demande les *login* et mot de passe de la
machine du *reverse proxy*.

> [!WARNING]  
> La procédure durant la phase de transition de
> [GitBucket](https://gitbucket.inist.fr/tdm/web-services) à GitHub était plus
> complexe, et permettait la publication (via `make publish`) avant d'avoir
> fusionné la *Pull Request*.  
> La nouvelle manière de faire implique que la PR soit fusionnée dans la branche
> principale, afin de ne pas configurer le *reverse proxy* avec des
> `swagger.json` obsolètes.  
