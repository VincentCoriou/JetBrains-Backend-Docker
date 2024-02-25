ARG BASE_IMAGE=ubuntu:22.04

# ==================== JETBRAINS ====================
FROM ${BASE_IMAGE} as jetbrains

ARG JETBRAINS_CLIENTS_DOWNLOADER_VERSION=1867
ARG JETBRAINS_CLIENTS_DOWNLOADER_URL=https://download.jetbrains.com/idea/code-with-me/backend/jetbrains-clients-downloader-linux-x86_64-${JETBRAINS_CLIENTS_DOWNLOADER_VERSION}.tar.gz

RUN apt update && \
    apt -y --no-install-recommends install \
      curl \
      ca-certificates \
      jq \
      && \
    apt clean && \
    rm -rf "/var/lib/apt/lists/*"

WORKDIR /jetbrains

RUN mkdir "jetbrains-clients-downloader" && \
    curl -sL "${JETBRAINS_CLIENTS_DOWNLOADER_URL}" | tar xvzf - --strip 1 -C "jetbrains-clients-downloader"