#!/bin/sh -eux

case "$PACKER_BUILDER_TYPE" in

virtualbox-iso|virtualbox-ovf)
    major_version="`sed 's/^.\+ release \([.0-9]\+\).*/\1/' /etc/redhat-release | awk -F. '{print $1}'`";

    if [ "$major_version" -ge 6 ]; then
        # Fix slow DNS:
        # Add 'single-request-reopen' so it is included when /etc/resolv.conf is
        # generated
        # https://access.redhat.com/site/solutions/58625 (subscription required)
        echo 'RES_OPTIONS="single-request-reopen"' >>/etc/sysconfig/network;
        service network restart;
        echo 'Slow DNS fix applied (single-request-reopen)';
    fi
    ;;

esac

## Set the DNS
cat <<EOF > /etc/resolv.conf
domain fr.internal.com
nameserver 172.21.17.210
nameserver 172.21.17.212
search fr.internal.com internal.com us.internal.com ie.internal.com lb.internal.com sg.internal.com
EOF

export http_proxy="http://proxy:3128"
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export no_proxy="localhost,data.local,bitbucket.local"
