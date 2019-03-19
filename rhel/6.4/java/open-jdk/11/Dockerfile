FROM localhost:5000/aallrd/rhel-6.4-base:latest
MAINTAINER "aallrd@github"

ARG OPEN_JDK_VERSION="11.0.1"

ENV JAVA_HOME="/usr/java/jdk-${OPEN_JDK_VERSION}"
ENV PATH="${JAVA_HOME}/bin${PATH:+:${PATH}}"
ENV LD_LIBRARY_PATH="${JAVA_HOME}/bin${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

# We are using the Open JDK package from jdk.java.net/11/
RUN set -e `# exit on error` \
    && curl -s "http://rhelrepo/vendors/openjdk/openjdk-${OPEN_JDK_VERSION}_linux-x64_bin.tar.gz" --output "openjdk-${OPEN_JDK_VERSION}.tar.gz" \
    && mkdir -p /usr/java \
    && tar -xzf "openjdk-${OPEN_JDK_VERSION}.tar.gz" -C /usr/java \
    && rm "openjdk-${OPEN_JDK_VERSION}.tar.gz" \
    && ls "/usr/java/jdk-${OPEN_JDK_VERSION}" `# check if jdk path exists` \
    && ln -s /usr/java /usr/local/java `# create symlink for MX build systems`
