FROM localhost:5000/aallrd/rhel-6.4-maven-3.6.0:latest
MAINTAINER aallrd@github

# Set timezone to Paris
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD etc/security/limits.d/90-nproc.conf /etc/security/limits.d/90-nproc.conf

# Required for the build
RUN yum clean all && yum install -y \
  apr apr-util \
  helix-cli \
  doxygen \
  binutils \
  devtoolset-3-toolchain \
  devtoolset-3-libasan-devel.x86_64 \
  python27-python-2.7.8 \
  python27-python-devel-2.7.8 \
  openssl-1.0.1e-57.el6.x86_64 \
  openssl-devel-1.0.1e-57.el6.x86_64 \
  krb5-devel-1.10.3-10.el6.x86_64 \
# Installingpackaged RPMs
  internal-oracle-jdk-1.8.131 \
  internal-maven-3.6.0 \
  internal-ant-1.9.13 \
  internal-ant-contrib-1.0b3 \
  internal-mxbuild-devtoolset-gold-1.0 \
  internal-mxbuild-wrapper-1.0 \
  internal-sybase-open-client-minimal-16.0 \
  internal-oracle-database-minimal-18.1.0.0 \
  internal-msodbcsql-13.1.9.1 \
  internal-patchelf-0.9 \
  internal-logdistiller-1.1 \
  internal-symphony-7.2.0 \
  internal-datasynapse-6.2.0 \
  && yum clean all \
# Symlinking everything for the codeline configuration
  && mkdir -p /opt/oracle \
  && ln -snf /opt/internal/root/opt/oracle/18100_64 /opt/oracle/18100_64 \
  && mkdir -p /opt/sybase \
  && ln -snf /opt/internal/root/opt/sybase/oc16.0-EBF27632 /opt/sybase/oc16.0-EBF27632 \
  && mkdir -p /nfs_tools/Linux/2.6/microsoft/sqlserver/13.1 \
  && ln -snf /opt/internal/root/opt/microsoft/msodbcsql /nfs_tools/Linux/2.6/microsoft/sqlserver/13.1/msodbcsql \
  && mkdir -p /nfs_tools/common/logdistiller \
  && ln -snf /opt/internal/root/opt/logdistiller /nfs_tools/common/logdistiller/logdistiller-1.1 \
  && mkdir -p /nettools/symphony/7.2 \
  && ln -snf /opt/internal/root/opt/ibm/spectrumcomputing/soamapi /nettools/symphony/7.2/Compiled_SOAMAPI \
  && ln -snf /opt/internal/root/opt/ibm/spectrumcomputing/symphonyclient /nettools/symphony/7.2/symphonyClient \
  && cd /nettools/symphony/7.2/symphonyClient/ && ln -s client72 Client72 && cd $OLDPWD \
  && ln -snf /opt/internal/root/opt/ibm/spectrumcomputing/symphonyde /nettools/symphony/7.2/symphonyDE \
  && cd /nettools/symphony/7.2/symphonyDE/ && ln -s de72 DE72 && cd $OLDPWD \
  && mkdir -p /nettools/datasynapse \
  && ln -s /opt/internal/root/opt/tibco/gridserver /nettools/datasynapse/gridserver6.2 \
  && mkdir -p /nfs_tools/common/maven \
  && ln -snf /opt/internal/root/opt/maven /nfs_tools/common/maven/maven-3.6.0 \
  && mkdir -p /usr/local/java \
  && ln -snf /opt/internal/root/usr/java/jdk1.8.131 /usr/local/java/jdk1.8.0_131-x64 \
  && mkdir -p /nettools/bin \
  && ln -snf /opt/internal/root/bin/patchelf /nettools/bin/patchelf \
# Hardcoded data mounts everywhere
  && mkdir -p /src/new /genoff.new

# Create and run with user jenkins
# User ID 1001 mandatory for runtime access to mounted files
RUN groupadd -r jenkins \
  && useradd --no-log-init --create-home --system --gid jenkins --uid 1001 jenkins \
  && chown jenkins:jenkins /src/new /genoff.new
USER jenkins

RUN curl -s https://bitbucket.local/projects/INFRA/repos/bash-utils/raw/utils.sh \
  -o /home/jenkins/utils.sh
ADD run.sh /usr/local/bin
WORKDIR /src/new
ENTRYPOINT ["run.sh"]
CMD ["--help"]
