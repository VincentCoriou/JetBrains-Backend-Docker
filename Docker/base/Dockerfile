ARG BASE_IMAGE=ubuntu:22.04

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

RUN mkdir -m 755 -p "/var/run/sshd" && \
    augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile ".ssh/authorized_keys /etc/authorized_keys/%u"' && \
    augtool 'set /files/etc/ssh/sshd_config/PasswordAuthentication no'

RUN useradd -ms "/bin/bash" "${USER_NAME}" && echo "${USER_NAME}:1234" | chpasswd

COPY resources/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]