# rhel-6.4-base

Build a minimal RHEL 6.4 docker image from the original ISO file. 

## Requirements

- Ubuntu 16.04.3 LTS
- VirtualBox (5.1.30r118389)
- packer (1.1.3)
- docker (Docker version 17.05.0-ce, build 89658be)

## Jenkins integration

### seed DSL file

The `seed.groovy` file is a Jenkins DSL file that creates a pipeline Job from the `Jenkinsfile`.

It must be registered in the `jenkins/mother_seed.groovy` file in order to be automatically created during the seed jobs creation. 

### Jenkinsfile

The `Jenkinsfile` is a declarative pipeline for building this project.

## How to build as a standalone project

    git clone https://bitbucket.local/scm/infra/docker-images.git
    cd rhel/6.4/base
    packer build rhel-6.4-x86_64-docker-base.json
    docker images
      REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
      rhel-6.4-base       latest              23253b82612d        xx minutes ago      174MB
    docker login -u aallrd -p 'password' localhost:5000
    docker tag rhel-6.4-base localhost:5000/aallrd/rhel-6.4-base:latest
    docker push localhost:5000/aallrd/rhel-6.4-base:latest
