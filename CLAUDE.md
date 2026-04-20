# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Stonehenge is a local development environment toolset built on Docker. It provides a shared reverse proxy (Traefik), automatic SSL certificates (mkcert), and email catching (Mailpit) for multiple projects running simultaneously on a developer's machine.

The project is maintained at `github.com/druidfi/stonehenge` and targets macOS, Ubuntu, Fedora/RHEL, and Windows WSL2.

## Common Commands

```bash
make up           # Start Stonehenge (creates network, volume, certs, container)
make down         # Full teardown (removes containers, volumes, network)
make stop         # Pause without destroying state
make status       # Show container status and loaded SSH keys
make update       # Pull latest code and image
make upgrade      # Teardown + update + startup
make debug        # Show OS/arch detection and environment info
make help         # List all available make targets
make ping         # Test domain resolution
```

SSH key management:
```bash
make addkey KEY=~/.ssh/id_ed25519
make keys
```

Docker image building:
```bash
make docker-build    # Build local image (arm64)
make docker-release  # Build and push to GHCR (amd64 + arm64)
make docker-test     # Build and test startup locally
```

## Architecture

### Runtime Components
- **Traefik** — reverse proxy; intercepts Docker socket and routes HTTP/HTTPS to project containers by label
- **Mailpit** — SMTP catch-all at `mailpit.docker.so`
- **mkcert** — generates wildcard SSL cert for `*.docker.so` (or custom `DOCKER_DOMAIN`)
- **Nginx** — serves a catch-all page for unmatched domains

### Key Files
- `Makefile` — thin entry point; pulls in `make/*.mk` and `make/plugins/*.mk`
- `make/stonehenge.mk` — core targets: `up`, `down`, `stop`, `addkeys`
- `make/docker.mk` — image build targets
- `make/os.mk` — OS/arch detection (`IS_MACOS`, `IS_LINUX`, `DISTRO`, `IS_WSL2`, `ARCH`)
- `make/utilities.mk` — logging helpers, `debug` target
- `make/plugins/01-mkcert.mk` — cert generation; OS-specific install paths
- `compose.yaml` — single `stonehenge` service; mounts Docker socket, `./certs/`, `./traefik/dynamic/`, SSH volume
- `Dockerfile` — multi-stage: stage 1 builds Mailpit binary; stage 2 layers onto Traefik base
- `docker-bake.hcl` — multi-arch build config for GHCR releases
- `.env` — default values: `DOCKER_DOMAIN=docker.so`, `PREFIX=stonehenge`, image tag
- `install.sh` — one-liner installer; clones repo, runs `make up`, adds shell alias

### Project Integration Pattern
Downstream projects attach to Stonehenge by:
1. Joining the external `stonehenge-network` Docker network
2. Adding Traefik labels to their service containers

The `examples/` directory has working `compose.yaml` templates for Drupal, Laravel, Symfony, WordPress, Ghost, Hugo, and FrankenPHP.

### OS Detection Logic
`make/os.mk` sets variables consumed by other makefiles:
- `IS_MACOS` / `IS_LINUX`
- `DISTRO` — e.g., `ubuntu`, `fedora`, `rhel`
- `IS_WSL2`
- `ARCH` — `amd64` or `arm64`

Plugin makefiles (e.g., `01-mkcert.mk`) branch on these to select the correct package manager (`brew`, `apt`, `dnf`) and binary paths.

### Versioning
Major version tracked in `.env` via `STONEHENGE_VERSION` and `STONEHENGE_TAG`. Current branch is `5.x`; `3.x` is the older stable branch. `make rollback` switches back to 4.x.

## CI/CD

- `.github/workflows/docker.yml` — triggers on changes to `Dockerfile`, `docker-bake.hcl`, or `make/**`; builds and pushes multi-arch images to `ghcr.io/druidfi/stonehenge` with tags `5`, `5.2`, `latest`
- `.github/workflows/tests.yml` — existing test workflow

## Configuration

All defaults live in `.env`. Override at the command line:

```bash
make up DOCKER_DOMAIN=docker.mycompany.com
HTTPS_PORT=8443 HTTP_PORT=8080 SMTP_PORT=25 make up
```
