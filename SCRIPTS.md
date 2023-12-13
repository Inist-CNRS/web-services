# Scripts

Available scripts:

- generate:example-metadata
- generate:example-tests
- generate:service
- help
- publish
- test:local
- test:remote

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

## publish

Usage: `npm run publish`

Required: credentials for daf's production machine.

Publish all services:

- to Inist's reverse proxy (at `service-name.services.istex.fr`)
- to its OpenAPI's documentation (<https://openapi.services.istex.fr>)
- to its [Prometheus](https://prometheus.io/)

All services with a `swagger.json` containing an enabled `servers.url` (with a
`standard` value for `x-profil`) are published.

## test:local

Usage: `npm run test:local service-name`

Launch the tests from `services/service-name/tests.hurl` to
<http://localhost:31976>. The service has to be running.

## test:remote

Usage: `npm run test:remote service-name`

Launch the tests from `services/service-name/tests.hurl` to
<https://service-name.services.istex.fr>. The service has to be running.
