# Scripts

Available scripts:

- generate:example-metadata
- generate:example-tests
- generate:service
- help
- insert:description
- publish
- update:images
- test:local
- test:remote
- test:remotes

## generate:example-metadata

Usage: `npm run generate:example-metadata services/service-name exampleName|exampleIndex`

Output dot notation metadata for the example (`exampleName` in
`services/service-name/examples.http`), so that you copy it in the `.ini`
matching the query.

## generate:example-tests

Usage: `npm run generate:example-tests services/service-name`

Required: `services/service-name/examples.http` must exist

Create  `services/service-name/tests.hurl`

which can be used to test the service, locally, as well as remotely.

## generate:service

Usage: `npm run generate:service service-name`

Scaffold the `services/service-name` directory, and customize all required
files.

Example:

```bash
$ npm run generate:service first-test
Creating service first-test from template

Short description: Premier test
Long description : Pas vraiment le premier en fait.
Author name : François Parmentier
Author email: francois.parmentier@gmail.com
```

## help

Usage: `npm run help`

Display this help (file `SCRIPT.md`).

Help is colorized if you have `bat` installed.

See <https://github.com/sharkdp/bat>.

## insert:description

Usage: `npm run insert:description services/service-name/v1_path.md`

Insert the Markdown description of a route into the matching `.ini` metadata
(`post.description`).  
Convert multiline markdown into one-line metadata (using `^M` character).
Replace the `_` character in the markdown files names with `/`, to match the path of the `.ini`s to be modified.

Example:

```bash
$ npm run insert:description services/terms-extraction/v*.md

> web-services@1.0.0 insert:description
> ./bin/insert-description.sh services/terms-extraction/v1_teeft_en.md services/terms-extraction/v1_teeft_fr.md services/terms-extraction/v1_teeft_with-numbers_en.md services/terms-extraction/v1_teeft_with-numbers_fr.md

 - services/terms-extraction/v1/teeft/en.ini ✓
 - services/terms-extraction/v1/teeft/fr.ini ✓
 - services/terms-extraction/v1/teeft/with-numbers/en.ini ✓
 - services/terms-extraction/v1/teeft/with-numbers/fr.ini ✓
```

## publish

Usage: `npm run publish`

Required: credentials for daf's production machine.

Publish all services:

- to Inist's reverse proxy (at `service-name.services.istex.fr`)
- to its OpenAPI's documentation (<https://openapi.services.istex.fr>)
- to its [Prometheus](https://prometheus.io/)

All services with a `swagger.json` containing an enabled `servers.url` (with a
`standard` value for `x-profil`) are published.

## update:images

Usage `npm run update:images -- [--help | [--dry-run] <[bases/]image-name>]`

Required: `image-name` should be a base image name, or a path to a base image
(`bases/image-name`).

Update all `Dockerfile`s directly depending from a base image.  
Update the template too, when it is the image used.  

> **Note**: when a base image depends from the given image, it will be updated,
> but no service depending from the latter will be updated, you have to run the
> script again, using the name of the latter image.

> **Reminder**: don't forget to build and push the base image before using this
> script.

### Parameters

- `--dry-run`: allow you to test your parameters, and will not execute any
  command, only show you what commands would be executed.
- `--help`: show the usage of the command

> **Note**: you only need `-- ` after script name when you use an option
> (beginning with `--`)

### Examples

```bash
$ npm run update:images -- --dry-run bases/ezs-python-server

> web-services@1.0.0 update:images
> ./bin/update-images.sh --dry-run bases/ezs-python-server

Update images depending from ezs-python-server (level )

Tag of the image: py3.9-no16-1.0.7

Directly depending images:
 - bases/ezs-python-saxon-server/Dockerfile
 - services/base-line/Dockerfile
 - services/base-line-python/Dockerfile
 - services/terms-extraction/Dockerfile
 - template/Dockerfile

Updating images:

 - bases/ezs-python-saxon-server/Dockerfile
sed -i -e "s/cnrsinist\/ezs-python-server:.*$/cnrsinist\/ezs-python-server:py3.9-no16-1.0.7/g" "bases/ezs-python-saxon-server/Dockerfile"
npm -w "bases/ezs-python-saxon-server" version patch
npm -w "bases/ezs-python-saxon-server" run build
npm -w "bases/ezs-python-saxon-server" run publish

***** Don't forget to run "updateBase bases/ezs-python-saxon-server" *******

 - services/base-line/Dockerfile
sed -i -e "s/cnrsinist\/ezs-python-server:.*$/cnrsinist\/ezs-python-server:py3.9-no16-1.0.7/g" "services/base-line/Dockerfile"
npm -w "services/base-line" version patch

 - services/base-line-python/Dockerfile
sed -i -e "s/cnrsinist\/ezs-python-server:.*$/cnrsinist\/ezs-python-server:py3.9-no16-1.0.7/g" "services/base-line-python/Dockerfile"
npm -w "services/base-line-python" version patch

 - services/terms-extraction/Dockerfile
sed -i -e "s/cnrsinist\/ezs-python-server:.*$/cnrsinist\/ezs-python-server:py3.9-no16-1.0.7/g" "services/terms-extraction/Dockerfile"
npm -w "services/terms-extraction" version patch

 - template/Dockerfile
sed -i -e "s/cnrsinist\/ezs-python-server:.*$/cnrsinist\/ezs-python-server:py3.9-no16-1.0.7/g" "template/Dockerfile"
git add template
git commit -m "Update template to ezs-python-server:py3.9-no16-1.0.7"
git push
```

```bash
$ npm run update:images -- --help

> web-services@1.0.0 update:images
> ./bin/update-images.sh --help

Usage: ./bin/update-images.sh [--help | [--dry-run] <[bases/]image-name>]
```

## test:local

Usage: `npm run test:local service-name`

Launch the tests from `services/service-name/tests.hurl` to
<http://localhost:31976>. The service has to be running.

## test:remote

Usage: `npm run test:remote service-name`

Launch the tests from `services/service-name/tests.hurl` to
<https://service-name.services.istex.fr>. The service has to be running.

## test:remotes

Usage: `npm run test:remotes [services/service-name]...`

Launch several services tests from `services/service-name/tests.hurl` to
<https://service-name.services.istex.fr>. The service has to be running.

Contrary to `test:remote`, it can launch the tests for several services in
production.

Without argument, it tests all services.

With path(s) to service(s), it will only test the selected services.

Examples:

```bash
npm run test:remotes services/* # Test all services
npm run test:remotes services/base-line services/terms-extraction # Test only 2 services
```
