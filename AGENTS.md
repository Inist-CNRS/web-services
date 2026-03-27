# AGENTS.md

This file provides guidelines for agents working in this codebase.

## Environment Setup

- **Node.js**: 24.7.0 (use `nvm install` to install from `.nvmrc`)
- **Package manager**: npm 7+ (npm workspaces)
- Install dependencies: `npm install` at repository root

## Build/Lint/Test Commands

### Service Development

```bash
# Start/stop local service (Docker-based)
npm -w services/<name> run start:dev
npm -w services/<name> run stop:dev

# Build Docker image (tag: latest)
npm -w services/<name> run build:dev

# Lint Dockerfile with hadolint
npm -w services/<name> run build:check
```

### Testing

```bash
# Generate tests.hurl from examples.http
npm run generate:example-tests services/<name>

# Run tests (service must be running locally)
HURL_blocked=false npm run test:local <name>

# Run tests against production
HURL_blocked=false npm run test:remote <name>

# Run tests for multiple services in production
HURL_blocked=false npm run test:remotes services/*

# Single test with hurl directly
HURL_blocked=false hurl --test --variable host=http://localhost:31976 --jobs 1 services/<name>/tests.hurl
```

> **Note**: `HURL_blocked=false` is required for tests accessing protected APIs (e.g., ISTEX services). Export it in `~/.bashrc` to avoid repeating it:
> ```sh
> export HURL_blocked=false
> ```

## Code Style

### EditorConfig

- **Encoding**: UTF-8
- **Line endings**: LF
- **Python/JS/MJS**: 4-space indentation
- **JSON/YAML/GitHub workflows**: 2-space indentation

### Service Structure

Each service in `services/<name>/` contains:

| File/Directory | Description |
|----------------|-------------|
| `v1/` (or `v2/`) | Route definitions in `.ini` files (ezs language) |
| `examples.http` | HTTP request examples for documentation and test generation |
| `tests.hurl` | Generated test file (hurl format) |
| `swagger.json` | OpenAPI documentation |
| `Dockerfile` | Based on `ezs-python-server` |
| `package.json` | npm package (name: `ws-<name>`, version: `0.0.0`) |

### ezs (`.ini`) Files

ezs reuses `.ini` syntax for IDE colorization. Files contain:

- **Statements**: `[use]`, `[JSONParse]`, `[assign]`, `[exec]`, `[dump]`, etc.
- **OpenAPI metadata**: Dot notation at the top (e.g., `post.summary`, `post.description`, `post.tags.0`)
- **Expressions**: Support lodash-style functions and JavaScript

Example:
```ini
# OpenAPI Documentation
post.summary = My route summary
post.description = Detailed description
mimeType = application/json

[use]
plugin = @ezs/basics

[JSONParse]

[assign]
path = value
value = get('value').deburr().upperCase()

[dump]
```

### Python Scripts

Used within ezs via the `[exec]` statement:

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys

for line in sys.stdin:
    data = json.loads(line)
    # process data...
    sys.stdout.write(json.dumps(data, ensure_ascii=False))
    sys.stdout.write('\n')
```

- Shebang line required
- UTF-8 encoding declaration
- JSON I/O via stdin/stdout (one JSON object per line)
- Dependencies pinned with exact versions in Dockerfile

### Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Service directory | lowercase, 2+ hyphenated parts | `base-line`, `terms-extraction` |
| Branch | `services/<name>/<description>` | `services/base-line/add-route` |
| npm package | `ws-<service-name>` | `ws-base-line` |
| OpenAPI operationId | `post-v1-<route>` | `post-v1-no-accent` |

## Branch Naming

Branches must follow: `services/<service-name>/<description>`

- `services/` prefix triggers automatic service testing on GitHub Actions
- Two `/` required in branch name
- All lowercase, no accents, words separated by hyphens

Examples:
- `services/base-line/add-route-lowercase`
- `services/terms-extraction/fix-teeft-parser`

## Adding a New Service

Use the scaffolding script:

```bash
npm run generate:service service-name
```

This creates the directory structure and all required files. Then:

1. Write examples in `examples.http`
2. Implement routes in `v1/` directory
3. Generate tests: `npm run generate:example-tests services/<name>`
4. Start service: `npm -w services/<name> run start:dev`

## Dockerfile Best Practices

- Install packages in a single command to avoid multiple layers:
  ```dockerfile
  RUN apt-get update && apt-get -y --no-install-recommends install \
      package1=version \
      package2=version \
      && apt-get clean && rm -rf /var/lib/apt/lists/*
  ```
- Use `--no-cache-dir` for pip installs
- Use `--omit=dev` for npm installs
- Pin package versions explicitly
- Do not add `CMD` or `ENTRYPOINT` (base image provides them)
- Use `COPY --chown=daemon:daemon` for config files

## Key Scripts

| Script | Purpose |
|--------|---------|
| `generate:service` | Scaffold new service |
| `generate:example-tests` | Generate tests.hurl |
| `generate:example-metadata` | Generate OpenAPI metadata |
| `insert:description` | Insert markdown descriptions into .ini files |
| `update:images` | Update dependent images after base image change |
| `publish` | Deploy services to production |
