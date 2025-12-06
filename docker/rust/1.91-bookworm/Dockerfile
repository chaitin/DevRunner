# Rust developer image based on DevRunner base (Debian bookworm)
ARG BASE_IMAGE=ghcr.io/chaitin/monkeycode-runner/base:bookworm
FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.title="DevRunner Rust" \
      org.opencontainers.image.source="https://github.com/chaitin/DevRunner" \
      org.opencontainers.image.description="Rust developer toolbox image for DevRunner stacks"

ARG DEBIAN_FRONTEND=noninteractive
ARG RUST_VERSION=1.91.1
ARG RUST_SHA256_AMD64=db178028da493a663b2e344a142076fb0f72adea4120043983f488de9cf95214
ARG RUST_SHA256_ARM64=be340c296bd18ad50a8af4f6c22fc744018f269f94474bdaf705da946803d64a

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

ENV PATH=/usr/local/bin:${PATH} \
    RUST_VERSION=${RUST_VERSION}

RUN set -eux; \
    rust_os="${TARGETOS:-linux}"; \
    rust_arch=""; \
    rust_sha256=""; \
    case "${TARGETARCH:-amd64}" in \
      amd64) rust_arch="x86_64-unknown-${rust_os}-gnu"; rust_sha256="${RUST_SHA256_AMD64}" ;; \
      arm64) rust_arch="aarch64-unknown-${rust_os}-gnu"; rust_sha256="${RUST_SHA256_ARM64}" ;; \
      "") rust_arch="x86_64-unknown-${rust_os}-gnu"; rust_sha256="${RUST_SHA256_AMD64}" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}${TARGETVARIANT:+ (${TARGETVARIANT})}" >&2; exit 1 ;; \
    esac; \
    curl -fsSLO "https://static.rust-lang.org/dist/rust-${RUST_VERSION}-${rust_arch}.tar.xz"; \
    echo "${rust_sha256}  rust-${RUST_VERSION}-${rust_arch}.tar.xz" | sha256sum -c -; \
    tar -xJf "rust-${RUST_VERSION}-${rust_arch}.tar.xz"; \
    "rust-${RUST_VERSION}-${rust_arch}/install.sh" --prefix=/usr/local --verbose; \
    rm -rf "rust-${RUST_VERSION}-${rust_arch}" "rust-${RUST_VERSION}-${rust_arch}.tar.xz"; \
    rustc --version; \
    cargo --version; \
    rustfmt --version

WORKDIR /workspace
