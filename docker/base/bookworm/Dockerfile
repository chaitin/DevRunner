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
COPY docker/base/bookworm/certs/chaitin-ltd-root-ca.crt /usr/local/share/ca-certificates/chaitin-ltd-root-ca.crt

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
        git-lfs \
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
        zsh \
    && GH_VERSION="2.89.0"; \
    arch=$(dpkg --print-architecture); \
    case "${arch}" in \
        amd64) gh_arch="amd64" ;; \
        arm64) gh_arch="arm64" ;; \
        *) echo "Unsupported architecture: ${arch}" && exit 1 ;; \
    esac; \
    curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${gh_arch}.tar.gz" \
        -o /tmp/gh.tar.gz; \
    tar -xzf /tmp/gh.tar.gz -C /tmp; \
    mv /tmp/gh_${GH_VERSION}_linux_${gh_arch}/bin/gh /usr/local/bin/gh; \
    rm -rf /tmp/gh.tar.gz /tmp/gh_${GH_VERSION}_linux_${gh_arch} \
    && ln -sf /usr/bin/vim.tiny /usr/bin/vim \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /workspace

RUN set -eux; \
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git /root/.oh-my-zsh; \
    rm -rf /root/.oh-my-zsh/.git; \
    cp /root/.oh-my-zsh/templates/zshrc.zsh-template /root/.zshrc; \
    chsh -s /usr/bin/zsh root

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    PATH=/root/.local/bin:${PATH} \
    DISABLE_AUTO_UPDATE=true \
    UPDATE_ZSH_DAYS=99999 \
    ZSH_DISABLE_COMPFIX=true \
    SHELL=/usr/bin/zsh \
    WORKSPACE=/workspace

WORKDIR /workspace
