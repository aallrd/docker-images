# rhel-6.4-maven-3.5.4

Build a docker image with Maven 3.5.4 from the latest RHEL 6.4 JDK 8 docker image.

## Usage

```
docker run --rm -it localhost:5000/aallrd/rhel-6.4-maven-3.5.4:latest mvn --version
Apache Maven 3.5.4 (1edded0938998edf8bf061f1ceb3cfdeccf443fe; 2018-06-17T14:33:14-04:00)
Maven home: /opt/internal/root/opt/maven
Java version: 1.8.0_131, vendor: Oracle Corporation, runtime: /opt/internal/root/usr/java/jdk1.8.131/jre
Default locale: en_US, platform encoding: ANSI_X3.4-1968
OS name: "linux", version: "4.4.0-141-generic", arch: "amd64", family: "unix"
```

## Build requirements

- Ubuntu 16.04.3 LTS
- docker (Docker version 17.05.0-ce, build 89658be)

## How to build as a standalone project

    git clone https://bitbucket.local/scm/infra/docker-images.git
    cd rhel/6.4/maven/3.5.4
    docker build -t rhel-6.4-maven-3.5.4 .
    docker login -u aallrd -p 'password' localhost:5000
    docker tag rhel-6.4-maven-3.5.4 localhost:5000/aallrd/rhel-6.4-maven-3.5.4:latest
    docker push localhost:5000/aallrd/rhel-6.4-maven-3.5.4:latest

## Jenkins integration

### seed DSL file

The `seed.groovy` file is a Jenkins DSL file that creates a pipeline Job from the `Jenkinsfile`.

It must be registered in the `jenkins/mother_seed.groovy` file in order to be automatically created during the seed jobs creation. 

### Jenkinsfile

The `Jenkinsfile` is a declarative pipeline for building this project.
