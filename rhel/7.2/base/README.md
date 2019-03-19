# rhel-7.2-base

Build a minimal RHEL 7.2 docker image from the original ISO file. 

## Usage

    docker run --rm -it localhost:5000/aallrd/rhel-7.2-base:latest cat /etc/redhat-release
    Red Hat Enterprise Linux Server release 7.2 (Maipo)

## Build requirements

- Ubuntu 16.04.3 LTS
- VirtualBox (5.1.30r118389)
- packer (1.1.3)
- docker (Docker version 17.05.0-ce, build 89658be)

## How to build as a standalone project

    git clone https://bitbucket.local/scm/infra/docker-images.git
    cd rhel/7.2/base
    packer build rhel-7.2-x86_64-docker-base.json
    docker images ls
      REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
      rhel-7.2            latest              612747ce68d8        xx minutes ago      249MB
    docker login -u aallrd -p 'password' localhost:5000
    docker tag rhel-7.2-base localhost:5000/aallrd/rhel-7.2-base:latest
    docker push localhost:5000/aallrd/rhel-7.2-base:latest

## Jenkins integration

### seed DSL file

The `seed.groovy` file is a Jenkins DSL file that creates a pipeline Job from the `Jenkinsfile`.

It must be registered in the `jenkins/mother_seed.groovy` file in order to be automatically created during the seed jobs creation. 

### Jenkinsfile

The `Jenkinsfile` is a declarative pipeline for building this project.
