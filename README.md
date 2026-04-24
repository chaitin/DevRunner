# DevRunner

Base container images for Chaitin MonkeyCode developer workflows.

## Base image (bookworm)
- Dockerfile: `docker/base/bookworm/Dockerfile` (Debian bookworm-slim, git/git-lfs/curl/build-essential/python3/gh, Chaitin root CA, en_US.UTF-8 locale, default user root).
- Build locally: `STACK=base VERSION=bookworm ./scripts/build.sh`
- Push to GHCR: `PUSH=true REGISTRY=ghcr.io/chaitin/monkeycode-runner STACK=base VERSION=bookworm ./scripts/build.sh` (needs `docker login ghcr.io`).
- Override apt mirrors by setting `DEBIAN_MIRROR` / `DEBIAN_SECURITY_MIRROR` before building.
- Example (TUNA mirror in mainland China):

  ```bash
  DEBIAN_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/debian \
  DEBIAN_SECURITY_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/debian-security \
  STACK=base VERSION=bookworm ./scripts/build.sh
  ```

- Run: `docker run --rm -it ghcr.io/chaitin/monkeycode-runner/base:bookworm bash`

## Devbox image (bookworm) - All-in-one Development Environment
- Dockerfile: `docker/devbox/bookworm/Dockerfile` (extends base image with Go 1.25.6, Node.js 22.22.0 LTS, Python 3.11, and diagnostic tools).
- Build locally: `STACK=devbox VERSION=bookworm ./scripts/build.sh`
- Push to GHCR: `PUSH=true REGISTRY=ghcr.io/chaitin/monkeycode-runner STACK=devbox VERSION=bookworm ./scripts/build.sh`
- Run: `docker run --rm -it ghcr.io/chaitin/monkeycode-runner/devbox:bookworm bash`

### Included Tools:
- **Go 1.25.6**: with staticcheck, gofumpt, swag
- **Node.js 22.22.0**: with Corepack (pnpm, yarn enabled)
- **Python 3.11**: with pip (PIP_BREAK_SYSTEM_PACKAGES enabled)
  - Pre-installed packages: requests, flask, django, beautifulsoup4, scrapy
- **Git LFS**: inherited from the base image and available as `git-lfs`
- **Diagnostic tools**: htop, iputils-ping, iproute2, wget

### Example Usage:
```bash
# Run the container
docker run --rm -it -v $(pwd):/workspace ghcr.io/chaitin/monkeycode-runner/devbox:bookworm bash

# Inside the container:
go version      # Go 1.25.6
node --version  # v22.22.0
python3 --version  # 3.11.x
git-lfs --version
npm install     # Works with Corepack enabled
python3 -c "import requests; print('requests:', requests.__version__)"  # 2.32.5
python3 -c "import flask; print('flask:', flask.__version__)"  # 3.1.2
python3 -c "import django; print('django:', django.VERSION)"  # (5, 2, 10, 'final', 0)
python3 -c "import scrapy; print('scrapy:', scrapy.__version__)"  # 2.14.1
```

## Frontend image (node20)
- Dockerfile: `docker/frontend/node20/Dockerfile` (extends base image with Node.js 20 and Corepack for frontend tooling).
- Build locally: `STACK=frontend VERSION=node20 ./scripts/build.sh`
- Push to GHCR: `PUSH=true REGISTRY=ghcr.io/chaitin/monkeycode-runner STACK=frontend VERSION=node20 ./scripts/build.sh`
- Run: `docker run --rm -it ghcr.io/chaitin/monkeycode-runner/frontend:node20 node --version`

## Go image (1.25-bookworm)
- Dockerfile: `docker/golang/1.25-bookworm/Dockerfile` (extends the base image, installs Go 1.25.5 plus `staticcheck`, `gofumpt`, `swag`, `golangci-lint`).
- Build locally: `STACK=golang VERSION=1.25-bookworm ./scripts/build.sh`
- Push to GHCR: `PUSH=true REGISTRY=ghcr.io/chaitin/monkeycode-runner STACK=golang VERSION=1.25-bookworm ./scripts/build.sh`
- Run: `docker run --rm -it ghcr.io/chaitin/monkeycode-runner/golang:1.25-bookworm bash`

## Rust image (1.91-bookworm)
- Dockerfile: `docker/rust/1.91-bookworm/Dockerfile` (extends the base image, installs Rust 1.91.1 via the official tarball with checksum verification).
- Build locally: `STACK=rust VERSION=1.91-bookworm ./scripts/build.sh`
- Push to GHCR: `PUSH=true REGISTRY=ghcr.io/chaitin/monkeycode-runner STACK=rust VERSION=1.91-bookworm ./scripts/build.sh`
- Run: `docker run --rm -it ghcr.io/chaitin/monkeycode-runner/rust:1.91-bookworm rustc --version`

## Java image (21-bookworm)
- Dockerfile: `docker/java/21-bookworm/Dockerfile` (extends the base image, installs OpenJDK 21.0.2 from the official OpenJDK download archive, plus Maven 3.9.14 and Gradle 9.4.1 from their official distribution endpoints with checksum verification).
- Build locally: `STACK=java VERSION=21-bookworm ./scripts/build.sh`
- Push to GHCR: `PUSH=true REGISTRY=ghcr.io/chaitin/monkeycode-runner STACK=java VERSION=21-bookworm ./scripts/build.sh`
- Run: `docker run --rm -it ghcr.io/chaitin/monkeycode-runner/java:21-bookworm bash`

## Layout
- `docker/base/bookworm/Dockerfile` – base image definition.
- `docker/devbox/bookworm/Dockerfile` – all-in-one devbox with Go, Node.js, and Python.
- `docker/frontend/node20/Dockerfile` – Node.js frontend developer image.
- `docker/golang/1.25-bookworm/Dockerfile` – Go developer image (bookworm + Go 1.25).
- `docker/rust/1.91-bookworm/Dockerfile` – Rust developer image (bookworm + Rust 1.91).
- `docker/java/21-bookworm/Dockerfile` – Java developer image (bookworm + JDK 21, Maven, Gradle).
- `scripts/build.sh` – helper to build/push images (env-driven: STACK, VERSION, REGISTRY, PUSH).
- `docs/` – docs placeholder for future stacks and CI notes.

## CI/CD
- Workflow: `.github/workflows/ci.yaml`
  - PR: build only (no push).
  - Push to `main` branch: login to GHCR with `GITHUB_TOKEN` and push tags from metadata (`bookworm`, `latest`, branch/tag-derived). Non-main branches/tags build only. Target registry: `ghcr.io/chaitin/monkeycode-runner`.
- No personal access token needed; workflow requests `packages: write` and `contents: read` via `GITHUB_TOKEN` (ensure Actions permissions allow this if repository is restricted).
