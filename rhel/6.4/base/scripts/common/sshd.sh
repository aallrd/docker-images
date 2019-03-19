#!/bin/sh -eux

SSHD_CONFIG="/etc/ssh/sshd_config"

# ensure that there is a trailing newline before attempting to concatenate
sed -i -e '$a\' "${SSHD_CONFIG}"

#USEDNS="UseDNS no"
#if grep -q -E "^[[:space:]]*UseDNS" "${SSHD_CONFIG}"; then
#    sed -i "s/^\s*UseDNS.*/${USEDNS}/" "${SSHD_CONFIG}"
#else
#    echo "${USEDNS}" >>"${SSHD_CONFIG}"
#fi
#
#GSSAPI="GSSAPIAuthentication no"
#if grep -q -E "^[[:space:]]*GSSAPIAuthentication" "${SSHD_CONFIG}"; then
#    sed -i "s/^\s*GSSAPIAuthentication.*/${GSSAPI}/" "${SSHD_CONFIG}"
#else
#    echo "${GSSAPI}" >>"${SSHD_CONFIG}"
#fi
#
## Speed up SSH by disabling DNS checks for clients
#LOOKUPCLIENTHOSTNAMES="LookupClientHostnames no"
#if grep -q -E "^[[:space:]]*LookupClientHostnames" "${SSHD_CONFIG}"; then
#    sed -i "s/^\s*LookupClientHostnames.*/${LOOKUPCLIENTHOSTNAMES}/" "${SSHD_CONFIG}"
#else
#    echo "${LOOKUPCLIENTHOSTNAMES}" >>"${SSHD_CONFIG}"
#fi

echo "Port 22" >>"${SSHD_CONFIG}"
echo "AddressFamily any" >>"${SSHD_CONFIG}"
echo "ListenAddress 0.0.0.0" >>"${SSHD_CONFIG}"
echo "ListenAddress ::" >>"${SSHD_CONFIG}"
echo "PubkeyAuthentication yes" >>"${SSHD_CONFIG}"
echo "X11Forwarding yes" >>"${SSHD_CONFIG}"
echo "UsePAM no" >>"${SSHD_CONFIG}"
echo "UseDNS no" >>"${SSHD_CONFIG}"
echo "${SSHD_CONFIG}:" && tail -50 ${SSHD_CONFIG}

