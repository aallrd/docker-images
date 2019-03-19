FROM localhost:5000/aallrd/rhel-6.4-maven-3.6.0:latest
MAINTAINER aallrd@github

# Set timezone to Paris
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD etc/security/limits.d/90-nproc.conf /etc/security/limits.d/90-nproc.conf

# Required for the build
RUN yum clean all && yum install -y \
  helix-cli \
  doxygen \
  htmldoc \
# Installingpackaged RPMs
  internal-oracle-jdk-1.8.131 \
  internal-maven-3.6.0 \
  internal-ant-1.9.13 \
  internal-ant-contrib-1.0b3 \
  internal-logdistiller-1.1 \
  internal-p7zip-16.02 \
  && yum clean all \
# Symlinking everything for the codeline configuration
  && mkdir -p /nfs_tools/common/logdistiller \
  && ln -snf /opt/internal/root/opt/logdistiller /nfs_tools/common/logdistiller/logdistiller-1.1 \
  && mkdir -p /nfs_tools/common/maven \
  && ln -snf /opt/internal/root/opt/maven /nfs_tools/common/maven/maven-3.6.0 \
  && mkdir -p /usr/local/java \
  && ln -snf /opt/internal/root/usr/java/jdk1.8.131 /usr/local/java/jdk1.8.0_131-x64 \
  && mkdir -p /nfs_tools/Linux/2.6/p7zip_16.02 \
  && ln -snf /opt/internal/root/usr/libexec/p7zip /nfs_tools/Linux/2.6/p7zip_16.02/bin \
# Hardcoded data mounts everywhere
  && mkdir -p /src/new /genoff.new \
# Great idea to store htmldoc on /src/new
  && echo -e 'mkdir -p /src/new/releng/thirdparties/htmldoc/bin/Linux-i386\n\
ln -snf /usr/share/htmldoc/data /src/new/releng/thirdparties/htmldoc\n\
ln -snf /usr/share/htmldoc/fonts /src/new/releng/thirdparties/htmldoc\n\
ln -snf /usr/bin/htmldoc /src/new/releng/thirdparties/htmldoc/bin/Linux-i386/htmldoc'\
>> /etc/profile.d/htmldoc.sh

# Create and run with user jenkins, mandatory for signing the primary jars
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
