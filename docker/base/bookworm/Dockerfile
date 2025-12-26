# Stage that just provides an initialized CA trust store so HTTPS mirrors work
FROM debian:bookworm-slim AS base-ca
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Base developer-friendly image (Debian bookworm-slim)
FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="DevRunner Base" \
      org.opencontainers.image.source="https://github.com/chaitin/DevRunner" \
      org.opencontainers.image.description="Base toolbox image for DevRunner stacks"

ARG DEBIAN_FRONTEND=noninteractive
ARG DEBIAN_MIRROR="https://deb.debian.org/debian"
ARG DEBIAN_SECURITY_MIRROR="https://security.debian.org/debian-security"

COPY --from=base-ca /etc/ssl/certs/ /etc/ssl/certs/
COPY --from=base-ca /usr/share/ca-certificates/ /usr/share/ca-certificates/

RUN set -eux; \
    printf 'deb %s bookworm main contrib non-free non-free-firmware\n' "${DEBIAN_MIRROR}" > /etc/apt/sources.list; \
    printf 'deb %s bookworm-updates main contrib non-free non-free-firmware\n' "${DEBIAN_MIRROR}" >> /etc/apt/sources.list; \
    printf 'deb %s bookworm-security main contrib non-free non-free-firmware\n' "${DEBIAN_SECURITY_MIRROR}" >> /etc/apt/sources.list; \
    rm -f /etc/apt/sources.list.d/debian.sources

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        locales \
        curl \
        git \
        gnupg \
        build-essential \
        pkg-config \
        unzip \
        zip \
        less \
        vim-tiny \
        procps \
        python3 \
        python3-pip \
        ripgrep \
    && ln -sf /usr/bin/vim.tiny /usr/bin/vim \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /workspace

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    PATH=/root/.local/bin:${PATH} \
    WORKSPACE=/workspace

WORKDIR /workspace
