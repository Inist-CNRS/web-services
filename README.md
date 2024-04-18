# web-services

Web services at Inist-CNRS

This repository is a work in progress.

It will host the re-implemented web services that are currently at [Inist's
GitBucket](https://gitbucket.inist.fr/tdm/web-services), but using only Docker
images (inspired from
[ezmaster-apps](https://github.com/Inist-CNRS/ezmaster-apps), except that images
won't be as versatile: they won't install npm packages depending on their
`config.json`, nor pip packages depending on their `requirements.txt` at launch,
all installs should be done at image building).

## Contributing

All contributing instructions are in [CONTRIBUTING](CONTRIBUTING.md).

<!-- This section must be the last one, it's automatically rewritten -->
## Services

- [affiliation-rnsr](./services/affiliation-rnsr) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-affiliation-rnsr.svg)](https://hub.docker.com/r/cnrsinist/ws-affiliation-rnsr/)
- [affiliations-tools](./services/affiliations-tools) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-affiliations-tools.svg)](https://hub.docker.com/r/cnrsinist/ws-affiliations-tools/)
- [astro-ner](./services/astro-ner) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-astro-ner.svg)](https://hub.docker.com/r/cnrsinist/ws-astro-ner/)
- [base-line](./services/base-line) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-base-line.svg)](https://hub.docker.com/r/cnrsinist/ws-base-line/)
- [base-line-python](./services/base-line-python) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-base-line-python.svg)](https://hub.docker.com/r/cnrsinist/ws-base-line-python/)
- [biblio-ref](./services/biblio-ref) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-biblio-ref.svg)](https://hub.docker.com/r/cnrsinist/ws-biblio-ref/)
- [chem-ner](./services/chem-ner) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-chem-ner.svg)](https://hub.docker.com/r/cnrsinist/ws-chem-ner/)
- [data-computer](./services/data-computer) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-data-computer.svg)](https://hub.docker.com/r/cnrsinist/ws-data-computer/)
- [data-termsuite](./services/data-termsuite) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-data-termsuite.svg)](https://hub.docker.com/r/cnrsinist/ws-data-termsuite/)
- [data-wrapper](./services/data-wrapper) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-data-wrapper.svg)](https://hub.docker.com/r/cnrsinist/ws-data-wrapper/)
- [diseases-ner](./services/diseases-ner) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-diseases-ner.svg)](https://hub.docker.com/r/cnrsinist/ws-diseases-ner/)
- [irc3-species](./services/irc3-species) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-irc3-species.svg)](https://hub.docker.com/r/cnrsinist/ws-irc3-species/)
- [pdf-text](./services/pdf-text) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-pdf-text.svg)](https://hub.docker.com/r/cnrsinist/ws-pdf-text/)
- [terms-extraction](./services/terms-extraction) [![Docker Pulls](https://img.shields.io/docker/pulls/cnrsinist/ws-terms-extraction.svg)](https://hub.docker.com/r/cnrsinist/ws-terms-extraction/)
