ARG BASE_IMAGE=ubuntu:22.04

# ==================== JETBRAINS ====================
FROM ${BASE_IMAGE} as jetbrains

ARG JETBRAINS_CLIENTS_DOWNLOADER_VERSION=1867
ARG JETBRAINS_CLIENTS_DOWNLOADER_URL=https://download.jetbrains.com/idea/code-with-me/backend/jetbrains-clients-downloader-linux-x86_64-${JETBRAINS_CLIENTS_DOWNLOADER_VERSION}.tar.gz
ARG JETBRAINS_PRODUCT=PY
ARG JETBRAINS_PRODUCT_VERSION=233.13763.11

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
    curl -sL "${JETBRAINS_CLIENTS_DOWNLOADER_URL}" | tar xvzf - --strip 1 -C "jetbrains-clients-downloader" && \
    ./jetbrains-clients-downloader/bin/jetbrains-clients-downloader \
      --products-filter "${JETBRAINS_PRODUCT}" \
      --build-filter "${JETBRAINS_PRODUCT_VERSION}" \
      --platforms-filter "linux-x64" \
      --download-backends "products" \
      && \
    mkdir "/jetbrains/app" && \
    cd "products/backends" && \
    tar xvzf $(jq -r ".[].releases[].downloads.linux.link" products.json) -C /jetbrains/app --strip 1

# ==================== MICROMAMBA ====================
FROM ${BASE_IMAGE} as micromamba

ARG MICROMAMBA_VERSION=1.5.6
RUN apt update && \
    apt -y --no-install-recommends install \
      curl \
      ca-certificates \
      bzip2 \
      && \
    apt clean && \
    rm -rf "/var/lib/apt/lists/*"

RUN mkdir "/opt/micromamba" && \
    curl -L "https://micro.mamba.pm/api/micromamba/linux-64/${MICROMAMBA_VERSION}" | tar -xj -C "/opt/micromamba" "bin/micromamba"

RUN curl -L "https://raw.githubusercontent.com/jonashaag/micromamba-pycharm/master/conda" -o "/opt/micromamba/bin/conda"

# ==================== FINAL ====================
FROM ${BASE_IMAGE} as image

ARG USER_NAME=jetbrains

RUN apt update && \
    apt -y --no-install-recommends install \
      openssh-server \
      python3 \
      augeas-tools \
      && \
    apt clean && \
    rm -rf "/var/lib/apt/lists/*"

RUN augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile ".ssh/authorized_keys /etc/authorized_keys/%u"' && \
    augtool 'set /files/etc/ssh/sshd_config/PasswordAuthentication no'

RUN mkdir -m 755 -p "/var/run/sshd"

RUN useradd -ms "/bin/bash" "${USER_NAME}" && echo "${USER_NAME}:1234" | chpasswd

COPY --from=jetbrains --chmod=755 "/jetbrains/app" "/jetbrains"
COPY --from=micromamba --chmod=755 "/opt/micromamba/bin/micromamba" "/bin/micromamba"
COPY --from=micromamba --chmod=755 "/opt/micromamba/bin/conda" "/bin/conda"


USER ${USER_NAME}
RUN /jetbrains/bin/remote-dev-server.sh registerBackendLocationForGateway
RUN /bin/micromamba shell init -s bash -p ~/micromamba
COPY --chown=${USER_NAME} resources/entrypoint.sh /entrypoint.sh

EXPOSE 2222

USER root

CMD ["/entrypoint.sh"]