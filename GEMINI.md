# Gemini Code Assistant Context

This document provides context for the Gemini Code Assistant to understand the
`github-web-services` project.

## Project Overview

This is a monorepo for web services at Inist-CNRS. The project's goal is to
re-implement existing web services using Docker images. The services are built
on top of a common set of base images located in the `bases` directory.

The project uses Node.js and npm workspaces to manage the multiple services and
base images. Each service is located in its own directory under the `services`
directory.

The services are built using the EZS framework, and use `hurl` for testing.

## Building and Running

The project uses npm scripts for building, running, and testing the services.

### Building a service

To build a service, run the following command from the root of the project:

```bash
npm -w services/<service-name> run build:dev
```

Replace `<service-name>` with the name of the service you want to build.

### Running a service

To run a service, run the following command from the root of the project:

```bash
npm -w services/<service-name> run start:dev
```

This will start the service in a Docker container.

### Testing a service

To test a service, run the following command from the root of the project:

```bash
HURL_blocked=false npm run test:local <service-name>
```

## Development Conventions

The `CONTRIBUTING.md` file provides detailed instructions for developers. Here
are some of the key conventions:

* **Branching:** Branches should follow the pattern `services/<service-name>/<description>`.
* **Service Creation:** There is a script `generate:service` to scaffold a new service.
* **Versioning:** `npm version` is used to create new versions of services.
* **Deployment:** The `publish.sh` script is used to deploy services to production.
* **Commit Messages:** Commit messages should follow conventional commits (with
  the context being the service name): `action(<service-name>): <description>`.

## Key Files

* `README.md`: The main README file for the project.
* `CONTRIBUTING.md`: The contributing guidelines for the project.
* `package.json`: The main `package.json` file for the project, which defines
  the workspaces and scripts.
* `services/`: The directory containing all the services.
* `bases/`: The directory containing the base Docker images.
* `template/`: A template for creating new services.
