FROM localhost:5000/aallrd/rhel-6.4-base:latest
MAINTAINER "aallrd@github"

WORKDIR /home

RUN yum install -y "java-1.8.0-openjdk" \
        "python27-python-2.7.8" \
        "python27-python-devel-2.7.8" \
        "python27-python-pip" \
        "python27-python-wheel" \
        "python27-python-virtualenv" \
        "git" \
        "gcc-c++" \
        "gdb" \
    && source "/opt/rh/python27/enable" \
    && echo "source /opt/rh/python27/enable" >> /root/.bashrc \
    && pip install --upgrade "pip" \
    && pip install "xmlrunner" "coverage" \
    && yum clean all
