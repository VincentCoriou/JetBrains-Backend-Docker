#!/bin/sh

set -ex

DEFAULT_SSH_KEYS_DIR="/etc/ssh"
DEFAULT_SSHD_CONFIG="/etc/ssh/sshd_config"
DEFAULT_SSH_KEYS="rsa ecdsa ed25519"
DEFAULT_SSH_PORT="22"

ssh_keys_dir=${SSH_KEYS_DIR:-${DEFAULT_SSH_KEYS_DIR}}
sshd_config=${SSHD_CONFIG:-${DEFAULT_SSHD_CONFIG}}
ssh_keys=${SSH_KEYS:-${DEFAULT_SSH_KEYS}}
ssh_port=${SSH_PORT:-${DEFAULT_SSH_PORT}}

keys_path=""
for key in ${ssh_keys}
do
  key_path="${ssh_keys_dir%%/}/ssh_host_${key}_key"
  if [ ! -f "${key_path}" ]
  then
    ssh-keygen -q -N "" -t "${key}" -f "${key_path}"
  fi
  keys_path="${keys_path} -h ${key_path}"
done
eval "set -- $* ${keys_path}"

/usr/sbin/sshd -d -d -d -D -f "${sshd_config}" -p "${ssh_port}" "$@"