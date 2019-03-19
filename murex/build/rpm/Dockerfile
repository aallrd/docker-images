FROM localhost:5000/aallrd/rhel-6.4-base:latest
MAINTAINER "aallrd@github"

# Install the required tools for building RPM packages
RUN yum install -y \
  autoconf \
  automake \
  binutils \
  bison \
  flex \
  devtoolset-3-toolchain \
  gettext \
  libtool \
  make \
  patch \
  pkgconfig \
  redhat-rpm-config \
  rpm-build \
  rpmdevtools \
  which \
  gettext \
  chrpath \
  && yum clean all \
  && echo "source /opt/rh/devtoolset-3/enable" > /etc/profile.d/devtoolset-3.sh \
  && alternatives --install /usr/bin/g++ g++ /opt/rh/devtoolset-3/root/usr/bin/g++ 0 \
  && alternatives --install /usr/bin/gcc gcc /opt/rh/devtoolset-3/root/usr/bin/gcc 0

# Configure the Docker image entrypoint
RUN curl -s https://bitbucket.local/projects/INFRA/repos/bash-utils/raw/utils.sh -o /root/utils.sh
ADD run.sh /usr/local/bin
ENTRYPOINT ["run.sh"]
CMD ["--help"]
