# rhel-7.2-java-open-jdk-11

Build a java docker image with the Oracle JDK 11 latest certified update from the latest RHEL 7.2 base docker image.

## Usage

    docker run --rm -it localhost:5000/aallrd/rhel-7.2-java-open-jdk-11:latest java -version
    openjdk version "11.0.1" 2018-10-16
    OpenJDK Runtime Environment 18.9 (build 11.0.1+13)
    OpenJDK 64-Bit Server VM 18.9 (build 11.0.1+13, mixed mode)

## Build requirements

- Ubuntu 16.04.3 LTS
- docker (Docker version 17.05.0-ce, build 89658be)

## How to build as a standalone project

    git clone https://bitbucket.local/scm/infra/docker-images.git
    cd rhel/7.2/java/open-jdk/11
    docker build -t rhel-7.2-java-open-jdk-11 .
    docker login -u aallrd -p 'password' localhost:5000
    docker tag rhel-7.2-java-open-jdk-11 localhost:5000/aallrd/rhel-7.2-java-open-jdk-11:latest
    docker push localhost:5000/aallrd/rhel-7.2-java-open-jdk-11:latest

## Jenkins integration

### seed DSL file

The `seed.groovy` file is a Jenkins DSL file that creates a pipeline Job from the `Jenkinsfile`.

It must be registered in the `jenkins/mother_seed.groovy` file in order to be automatically created during the seed jobs creation. 

### Jenkinsfile

The `Jenkinsfile` is a declarative pipeline for building this project.
