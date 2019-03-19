FROM localhost:5000/aallrd/rhel-6.4-java-oracle-jdk-1.8.0:latest
MAINTAINER "aallrd@github"

ARG MAVEN_VERSION="maven-3.0.3-mx1"

ENV M2_HOME="/opt/maven/${MAVEN_VERSION}"
ENV PATH="${M2_HOME}/bin/:${PATH}"

RUN curl -s "http://rhelrepo/thirdparty/maven/${MAVEN_VERSION}.tar.gz" --output "${MAVEN_VERSION}.tar.gz" \
    && mkdir -p /opt/maven \
    && tar -xzf "${MAVEN_VERSION}.tar.gz" -C /opt/maven
