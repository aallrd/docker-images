FROM localhost:5000/aallrd/rhel-7.2-java-oracle-jdk-1.8.0:latest
MAINTAINER "aallrd@github"

ARG MAVEN_VERSION="apache-maven-3.6.0"

ENV M2_HOME="/opt/maven/${MAVEN_VERSION}"
ENV PATH="${M2_HOME}/bin/:${PATH}"

RUN curl -s "http://rhelrepo/thirdparty/maven/${MAVEN_VERSION}-bin.tar.gz" --output "${MAVEN_VERSION}.tar.gz" \
    && mkdir -p /opt/maven \
    && tar -xzf "${MAVEN_VERSION}.tar.gz" -C /opt/maven \
    && rm "${MAVEN_VERSION}.tar.gz"
