FROM localhost:5000/aallrd/rhel-6.4-base:latest
MAINTAINER aallrd@github

RUN yum clean all \
    && yum install -y helix-cli \
    yum clean all

# Create and run with user jenkins
RUN groupadd -r jenkins \
  && useradd --no-log-init --create-home --system --gid jenkins --uid 1001 jenkins
USER jenkins

RUN curl -s https://bitbucket.local/projects/INFRA/repos/bash-utils/raw/utils.sh \
  -o /home/jenkins/utils.sh
ADD perforce.sh /usr/local/bin
ENTRYPOINT ["perforce.sh"]
CMD ["--help"]
