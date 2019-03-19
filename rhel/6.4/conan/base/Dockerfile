FROM localhost:5000/aallrd/rhel-6.4-base:latest
MAINTAINER "aallrd@github"

# setup repos & install packages
RUN yum install -y "libtool" "m4" "autoconf" "automake" "make" "imake" "texinfo" \
                   "expat" "expat-devel" \
                   "zlib" "zlib-devel" \
                   "bzip2-devel" \
                   "byacc" "pcre-devel" \
                   "binutils" \
                   "rh-ruby24" "rh-ruby24-ruby-devel" \
                   "rh-maven33" \
                   "rh-python36-python" "rh-python36-python-pip" "rh-python36-python-devel" \
                   "python27-python-devel-2.7.8-18.el6" "python27-python-2.7.8-18.el6" \
    && source "/opt/rh/rh-python36/enable" \
    && pip3 install --upgrade "pip" \
    && pip3 install "execnet" \
    && source "/opt/rh/rh-ruby24/enable" \
    && gem install "bundler" \
    && yum clean all; \
    cmake_url="https://cmake.org/files/v3.13/"; \
    cmake_version_latest="cmake-3.13.3-Linux-x86_64.sh"; \
    curl -O "${cmake_url}${cmake_version_latest}"; \
    chmod +x "${cmake_version_latest}" && ./${cmake_version_latest} --prefix="/usr/local" --skip-license; \
    rm "${cmake_version_latest}"

# export the correct env variables
ENV PATH=/opt/rh/rh-maven33/root/usr/bin:/opt/rh/rh-java-common/root/usr/bin:/opt/rh/rh-python36/root/usr/bin:/opt/rh/python27/root/usr/bin:/opt/rh/rh-ruby24/root/usr/local/bin:/opt/rh/rh-ruby24/root/usr/bin${PATH:+:${PATH}} \
    LD_LIBRARY_PATH=/opt/rh/rh-python36/root/usr/lib64:/opt/rh/python27/root/usr/lib64:/opt/rh/rh-ruby24/root/usr/local/lib64:/opt/rh/rh-ruby24/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} \
    PYTHONPATH=/opt/rh/rh-maven33/root/usr/lib/python2.6/site-packages:/opt/rh/rh-java-common/root/usr/lib/python2.6/site-packages${PYTHONPATH:+:${PYTHONPATH}} \
    JAVACONFDIRS=/opt/rh/rh-maven33/root/etc/java:/opt/rh/rh-java-common/root/etc/java

# setupmaven configuration
COPY cfg/maven/settings.xml /opt/rh/rh-maven33/root/etc/maven/settings.xml

# install conan
RUN pip3 --proxy http://proxy:3128 install "conan==1.11.2" \
    && conan

# fetch the conan configuration from the server
# the cachebust arg is a workaround to avoid the docker cache mechanism
ARG CACHEBUST=1
RUN conan config install --verify-ssl=False https://conan.local/config
