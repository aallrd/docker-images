FROM localhost:5000/aallrd/rhel-7.2-base:latest
MAINTAINER "aallrd@github"

ARG JAVA_VERSION="jdk1.8.0_131"

ENV JAVA_HOME="/usr/java/${JAVA_VERSION}"

RUN set -e `# exit on error` \
    && yum install -y "${JAVA_VERSION}" \
    && ls /usr/java/"${JAVA_VERSION}" `# check if java path exists` \
    && ln -s /usr/java /usr/local/java `# create symlink for MX build systems` \
    && yum clean all
