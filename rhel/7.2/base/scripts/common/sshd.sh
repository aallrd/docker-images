#!/bin/sh -eux

SSHD_CONFIG="/etc/ssh/sshd_config"

# ensure that there is a trailing newline before attempting to concatenate
sed -i -e '$a\' "${SSHD_CONFIG}"

echo '==> Turning off sshd DNS lookup to prevent timeout delay'
echo "UseDNS no" >>"${SSHD_CONFIG}"
echo '==> Disabling GSSAPI authentication to prevent timeout delay'
echo "GSSAPIAuthentication no" >>"${SSHD_CONFIG}"

echo "${SSHD_CONFIG}:" && tail -50 ${SSHD_CONFIG}

