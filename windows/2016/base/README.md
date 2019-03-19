# windows-2016-base

Build a minimal Windows Server Core 2016 base image from the Microsoft docker hub.

## Requirements

- Ubuntu 16.04.3 LTS
- docker (Docker version 17.05.0-ce, build 89658be)

## Jenkins integration

### seed DSL file

The `seed.groovy` file is a Jenkins DSL file that creates a pipeline Job from the `Jenkinsfile`.

It must be registered in the `jenkins/mother_seed.groovy` file in order to be automatically created during the seed jobs creation. 

### Jenkinsfile

The `Jenkinsfile` is a declarative pipeline for building this project.

## How to build as a standalone project

    git clone https://bitbucket.local/scm/infra/docker-images.git
    cd windows/2016/base
    docker build . -t windows-2016-base
	docker image list
      REPOSITORY                    TAG                    IMAGE ID            CREATED             SIZE
      windows-2016-base             latest                 16962939a1c9        1 hours ago        11.6GB
    docker login -u aallrd -p 'password' localhost:5000
    docker tag windows-2016-base localhost:5000/aallrd/windows-2016-base:latest
    docker push localhost:5000/aallrd/windows-2016-base:latest
