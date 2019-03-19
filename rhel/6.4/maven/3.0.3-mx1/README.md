# rhel-6.4-maven-3.0.3-mx1

Build a docker image with Maven 3.0.3-mx1 from the latest RHEL 6.4 JDK 8 docker image.

## Usage

```
docker run --rm -it localhost:5000/aallrd/rhel-6.4-maven-3.0.3-mx1:latest mvn --version
Apache Maven 3.0.3 (r1075438; 2011-02-28 12:31:09-0500)
Maven home: /opt/maven/maven-3.0.3-mx1
Java version: 1.8.0_131, vendor: Oracle Corporation
Java home: /usr/java/jdk1.8.0_131/jre
Default locale: en_US, platform encoding: ANSI_X3.4-1968
OS name: "linux", version: "4.4.0-138-generic", arch: "amd64", family: "unix"
```

## Build requirements

- Ubuntu 16.04.3 LTS
- docker (Docker version 17.05.0-ce, build 89658be)

## How to build as a standalone project

    git clone https://bitbucket.local/scm/infra/docker-images.git
    cd rhel/6.4/maven/3.0.3-mx1
    docker build -t rhel-6.4-maven-3.0.3-mx1 .
    docker login -u aallrd -p 'password' localhost:5000
    docker tag rhel-6.4-maven-3.0.3-mx1 localhost:5000/aallrd/rhel-6.4-maven-3.0.3-mx1:latest
    docker push localhost:5000/aallrd/rhel-6.4-maven-3.0.3-mx1:latest

## Jenkins integration

### seed DSL file

The `seed.groovy` file is a Jenkins DSL file that creates a pipeline Job from the `Jenkinsfile`.

It must be registered in the `jenkins/mother_seed.groovy` file in order to be automatically created during the seed jobs creation. 

### Jenkinsfile

The `Jenkinsfile` is a declarative pipeline for building this project.
