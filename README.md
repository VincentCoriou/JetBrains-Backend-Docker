# JetBrains-Backend-Docker

This repository contains some helpers to build a base Docker image containing the requested JetBrains product backend as well as running an SSH server to access the backend through the JetBrains gateway.

## Image build arguments

| Docker argument                        | Description                                                                                                              |
|----------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| `JETBRAINS_PRODUCT`                    | The JetBrains product backend to download. Defaults to `PY`.                                                             |
| `JETBRAINS_PRODUCT_VERSION`            | The JetBrains product versionb to download. See [other versions](https://www.jetbrains.com/pycharm/download/other.html). |
| `JETBRAINS_CLIENTS_DOWNLOADER_VERSION` | The JetBrains client download version. Defaults to `1867`.                                                               |

## Runtime configuration

| Environment variable | Description                                                                                                 |
|----------------------|-------------------------------------------------------------------------------------------------------------|
| `SSH_KEYS_DIR`       | The directory containing the host keys the container should use for the SSH Server. Defaults to `/etc/ssh`. |
| `SSHD_CONFIG`        | The path to the `sshd_config` to use in the container. Defaults to `/etc/ssh/sshd_config`.                  |
| `SSH_KEYS`           | The different types of SSH keys to use/generate if missing. Defaults to `rsa ecdsa ed25519`.                |
| `SSH_PORT`           | The SSH port to use in the container. Defaults to `22`.                                                     |

