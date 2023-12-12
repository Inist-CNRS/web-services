# Scripts

Available scripts:

- generate:example-metadata
- generate:example-tests
- generate:service
- help

## generate:example-metadata

Usage: `npm run generate:example-metadata services/service-name exampleName|exampleIndex`

Output dot notation metadata for the example (`exampleName` in
`services/service-name/examples.http`), so that you copy it in the `.ini`
matching the query.

## generate:example-tests

Usage: `npm run generate:example-tests services/service-name`

Required: `services/service-name/examples.http` must exist

Create two files in `services/service-name`:

1. `local-tests.hurl`
2. `remote-tests.hurl`

which can be used to test the service.

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
