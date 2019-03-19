#!/bin/sh -eux

echo '==> Applying slow DNS fix'
if [[ "${PACKER_BUILDER_TYPE}" =~ "virtualbox" ]]; then
  ## https://access.redhat.com/site/solutions/58625 (subscription required)
  # http://www.linuxquestions.org/questions/showthread.php?p=4399340#post4399340
  # add 'single-request-reopen' so it is included when /etc/resolv.conf is generated
  echo 'RES_OPTIONS="single-request-reopen"' >> /etc/sysconfig/network
  service network restart
  echo '==> Slow DNS fix applied (single-request-reopen)'
else
  echo '==> Slow DNS fix not required for this platform, skipping'
fi

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
