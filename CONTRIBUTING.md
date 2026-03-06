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

> [!NOTE]  
> Seules les branches commençant par `services/` et contenant deux
> `/` déclencheront l'action de test du service.

> [!NOTE]  
> Comme nous construisons des programmes *open source*, tâchons
> de garder tout ce qui est technique (ça peut exclure la documentation
> elle-même) en anglais.

> [!NOTE]  
> Assurez-vous de partir de la branche `main` *à jour* (en faisant un
> `git pull origin main` *avant* de créer la branche).

## Création d'un service

Avant toute chose, il faut s'assurer qu'un service qui pourrait accueillir votre
nouvelle route n'existe pas déjà. Cela évitera de créer un nouveau service.

### Méthode recommandée : utiliser le script de génération

Pour créer un nouveau service, utilisez le script npm [`generate:service`](SCRIPTS.md#generateservice):

```bash
npm run generate:service service-name
```

Le nom du service doit être en minuscules, en au moins deux parties séparées
par un tiret (ex: `base-line`, `astro-ner`).

Le script vous demandera :
- Le titre du service (*short description*)
- La description détaillée (*long description*)
- Le nom de l'auteur et son email

Le script se charge automatiquement de :
- Créer le répertoire `services/service-name`
- Ajouter le service dans les *workspaces* du dépôt
- Générer tous les fichiers nécessaires (voir [Structure d'un service](#structure-dun-service))
- Ajouter le service dans la liste du [README](./README#services)

> [!WARNING]  
> Ne pas mettre de caractère `&` dans les réponses, ça provoque un
> remplacement bizarre.

### Après la génération

Une fois le service créé, vous devez :

1. **Écrire les exemples de requêtes** dans le fichier `examples.http`
   (voir [Format du fichier examples.http](#format-du-fichier-exampleshttp))

2. **Implémenter les routes** dans le répertoire `v1/`

3. **Générer les tests** une fois le serveur lancé :
   ```bash
   npm -w services/<instance> run start:dev
   # Dans un autre terminal :
   npm run generate:example-tests services/<instance>
   ```

### Structure d'un service

> [!NOTE]  
> Cette section décrit la structure créée automatiquement par le script
> `generate:service`. Elle sert de référence pour comprendre l'organisation
d'un service.

Chaque service est un répertoire dans `services/` contenant :

| Fichier/Répertoire    | Description                                                               |
| --------------------- | ------------------------------------------------------------------------- |
| `v1/` (ou `v2/`, ...) | Code source du service (fichiers `.ini` définissant les routes)           |
| `Dockerfile`          | Définition de l'image Docker, basée sur `ezs-python-server`               |
| `.dockerignore`       | Fichiers à exclure de l'image Docker                                      |
| `package.json`        | Configuration npm du service (nom: `ws-<service-name>`, version: `0.0.0`) |
| `swagger.json`        | Documentation OpenAPI (le titre doit commencer par le nom du service)     |
| `config.json`         | *(Optionnel)* Configuration par défaut du service                         |
| `README.md`           | Documentation du service                                                  |
| `examples.http`       | Exemples de requêtes HTTP pour chaque route                               |
| `tests.hurl`          | Tests générés automatiquement depuis `examples.http`                      |

Le nom du répertoire suit la convention ezmaster : au moins deux parties en
minuscules séparées par un tiret (ex: `base-line`, `astro-ner`).

Pour profiter du système de *workspaces* npm, le service est automatiquement
déclaré dans le `package.json` racine, permettant de lancer :

```bash
npm -w services/<service-name> run start:dev
npm -w services/<service-name> run stop:dev
```

### Format du fichier examples.http

Le fichier `examples.http` se situe à la racine du service.

> [!NOTE]  
> Ce fichier est initialisé automatiquement par le script `generate:service`.
> Il reste nécessaire d'écrire les requêtes pour chaque route créée.

Il sert à :
- Documenter les routes du service
- Générer les métadonnées d'exemple (via `generate:example-metadata`)
- Générer les tests (via `generate:example-tests`)

Structure du fichier :

```ini
# These examples can be used directly in VSCode, using REST Client extension (humao.rest-client)

# Décommenter/commenter les lignes voulues pour tester localement
@host=http://localhost:31976
# @host=https://base-line.services.istex.fr

###
# @name v1TrueJson
# Description de la route
POST {{host}}/v1/true/json HTTP/1.1
Content-Type: application/json

[
  { "value": "exemple" }
]
```

Chaque requête doit avoir :
- Un séparateur `###`
- Un nom unique (`# @name`) construit à partir de la route
- Une méthode HTTP (généralement `POST`)
- Un `Content-Type` (généralement `application/json`)
- Un corps de requête JSON

> [!TIP]  
> Comme ces exemples servent aussi aux tests, il est utile d'y
> mettre des cas de test variés.

### Génération des tests (tests.hurl)

Le fichier `tests.hurl` est généré automatiquement depuis `examples.http`.

Étapes :

1. Lancer le serveur :
  
  ```bash
  npm -w services/<instance> run start:dev
  # ou
  npx ezs -v -m -d services/<instance>/
  ```

2. Générer les tests :
  
  ```bash
  npm run generate:example-tests services/<instance>
  ```

> [!TIP]  
> `examples.http` doit contenir au moins un exemple.

Ce fichier sert lors des *push* sur GitHub pour tester la non-régression des
routes. Toutes les routes doivent être testées.

> [!NOTE]  
> On peut aussi écrire ce fichier à la main, voir [hurl](https://hurl.dev/).

> [!TIP]  
> Pour désactiver un test sur GitHub (si l'API vérifie l'IP) :
>
> ```ini
> [Options]
> skip: {{blocked}}
> ```

### OpenAPI: ajout d'une description multi-lignes dans les métadonnées du .ini

Lors de la rédaction du .ini, trois champs méritent particulièrement l'attention :

- `post.tags.0` qui permettra de configurer plus simplement `IA Factory`.
Pour une identification rapide, ce peut être le nom court que l'on donne au service.
- `post.summary` qui est affiché dans le menu déroulant de sélection de service
de `IA Factory`. Doit être explicite pour l'utilisateur et idéalement commencer
par le nom court du service
- `post.description` qui est affiché après sélection du service dans le menu
déroulant. Doit contenir une description plus détaillée ainsi que les précautions
que les utilisateurs et utilisatrices doivent prendre.

On peut écrire la description d'un service en Markdown, et donc l'écrire sur
plusieurs lignes.
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
    - entrer le login : `dvc remote modify --local webdav-remote user YOUR_LOGIN`
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

### Dockerfile: bonnes pratiques

Pour un rappel de beaucoup de bonnes pratiques, utilisez le script `build:check`
de votre service:

```bash
npm -w services/service-name run build:check
```

Il procède à une vérification statique du `Dockerfile` avec
[hadolint](https://github.com/hadolint/hadolint).

#### apt

Pour les paquets `apt`, il est conseillé de les installer en une seule commande,
afin d'éviter de lancer plusieurs fois la commande `apt-get update`.

Exemple:

```dockerfile
RUN apt-get update && apt-get -y --no-install-recommends install \
    libxml2-dev=2.9.10+dfsg-6.7+deb11u8 \
    libxslt1-dev=1.1.34-4+deb11u2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
```

- `apt-get update` est lancée en premier, pour mettre à jour la liste des paquets
- `apt-get -y --no-install-recommends install` installe les paquets
- `apt-get clean` supprime les caches des paquets téléchargés
- `rm -rf /var/lib/apt/lists/*` supprime la liste des paquets

> [!NOTE]  
> On installe les paquets avec la version explicite, pour éviter les
> mises à jour involontaires.

#### pip

Pour les paquets `pip` aussi, il est conseillé de les installer en une seule
commande, afin d'éviter de lancer plusieurs fois la commande `pip install`.

Pour supprimer les caches `pip` de l'image Docker, utilisez l'option
`--no-cache-dir`.

#### npm

Pour les paquets `npm`, il est conseillé de les installer en une seule commande,
afin d'éviter de créer plusieurs couches inutiles.

Ajoutez l'option `--omit=dev` à la commande `npm install`.  
Puis lancez `npm cache clean --force` à la fin de la commande.

#### Dockerfile

À savoir:

- l'image de base utilise le USER `root`, vous n'avez donc pas besoin de le
  préciser (et d'ailleurs, ce n'est à strictement parler pas une bonne pratique
  de sécurité). Sachez simplement que le serveur sera lancé par l'utilisateur
  `daemon`.
- ne mettez pas de `CMD` ou de `ENTRYPOINT` dans votre `Dockerfile`, l'image de
  base en contient déjà un. Évidemment, si vous avez besoin de lancer un
  serveur autre que celui de base, vous pouvez bien sûr en redéfinir un.
- le fichier `config.json` doit être mis dans `/app`, et appartenir à `daemon`.
  Utilisez de préférence `COPY --chown=daemon:daemon ./config.json
  /app/config.json`.

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

Pour vérifier que l'image respecte les bonnes pratiques, on peut utiliser la
commande `build:check`:

```bash
npm -w services/service-name run build:check
```

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

## Debug

Pour déboguer un service, il est possible d'ajouter la propriété `DEBUG` dans le
fichier `config.json` du service, et de la positionner à `ezs:*`.  
Il faut aussi mettre `EZS_VERBOSE` à `false` pour éviter une surcharge de cette
variable.  
Cela donne accès aux informations de débogage interne de `ezs`.  

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

> [!TIP]  
> Pour éviter qu'un service soit testé lorsqu'il est en production, on peut
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

> [!TIP]  
> Pour ne pas avoir à taper systématiquement `HURL_blocked=false` avant toute
> commande de lancement de tests, on peut exporter cette variable depuis son
> `~/.bashrc` (si vous utilisez bash):  
>
> ```sh
> # hurl variable to skip tests accessing protected (blocked) API
> # true: You are not able to access *.services.istex.fr
> # false: You are able to access *.services.istex.fr
> export HURL_blocked=false
> ```

## Ajout dans la liste du README

Une fois que le nouveau service est créé, il faut l'ajouter à la liste du README
de la racine du dépôt.

> [!NOTE]  
> Ceci est automatique quand on utilise le script
> [`generate:service`](SCRIPTS.md#generateservice).

## Les images de base

> [!WARNING]  
> Cette partie ne concerne pas directement l'écriture des services, mais plus
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

> [!NOTE]  
> Il existe maintenant un script qui se charge de la mise à jour des
> images qui dépendent directement d'une image de base: [`npm run update:images
> <image-name>`](./SCRIPTS.md#updateimages).  
> Assurez-vous que l'image a été créée (version, build, push) avant de lancer le
> script.  
> De même, faites en sorte que les dernières modifications de la branche `main`
> soient intégrées dans la branche de travail de la *pull request* (un `git
> merge main` devrait faire l'affaire), sous peine d'avoir des tags de version
> existant déjà, et interrompant la mise à jour du/des service/s en question.

## Création d'une version

Pour créer une version, on peut se servir de npm et du *workspace* associé au service en question.  
Exemple: `npm -w services/service-name version patch`.  
L'argument de `npm version` est `major`, `minor` ou `patch` suivant qu'il y a un
changement majeur, un ajout de fonctionnalité ou une correction.  

Cela va créer un tag, modifier le numéro de version dans le README, et pousser
le tout sur GitHub, déclenchant une action de Github qui poussera
automatiquement l'image sur Docker Hub.

> [!NOTE]  
> On peut aussi créer la version manuellement. Pour ça il faut se déplacer dans
> le répertoire du `Dockerfile` et lancer `npm version` en utilisant l'argument
> `major`, `minor` ou `patch` suivant qu'il y a un changement majeur, un ajout de
> fonctionnalité ou une correction.

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
