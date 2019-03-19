# rhel-6.4-java-open-jdk-11

Build a java docker image with the Oracle JDK 11 latest certified update from the latest RHEL 6.4 base docker image.

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
    cd rhel/6.4/java/open-jdk/11
    docker build -t rhel-6.4-java-open-jdk-11 .
    docker login -u aallrd -p 'password' localhost:5000
    docker tag rhel-6.4-java-open-jdk-11 localhost:5000/aallrd/rhel-6.4-java-open-jdk-11:latest
    docker push localhost:5000/aallrd/rhel-6.4-java-open-jdk-11:latest
