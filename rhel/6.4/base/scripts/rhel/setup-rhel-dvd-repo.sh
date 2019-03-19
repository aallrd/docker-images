#!/bin/bash
mount -o loop /dev/sr0  /mnt
cp /mnt/media.repo /etc/yum.repos.d/rhel6.4-dvd.repo
chmod 644 /etc/yum.repos.d/rhel6.4-dvd.repo
cat >> /etc/yum.repos.d/rhel6.4-dvd.repo <<EOF
enabled=1
baseurl=file:///mnt/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOF
