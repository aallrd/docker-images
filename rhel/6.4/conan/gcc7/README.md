# rhel-6.4-conan-gcc7

Build a conan docker image with the devtoolset-7 toolchain from the latest RHEL 6.4 conan base docker image. 

## Requirements

- Ubuntu 16.04.3 LTS
- docker (Docker version 17.05.0-ce, build 89658be)

## Jenkins integration

### seed DSL file

The `seed.groovy` file is a Jenkins DSL file that creates a pipeline Job from the `Jenkinsfile`.

It must be registered in the `jenkins/mother_seed.groovy` file in order to be automatically created during the seed jobs creation. 

### Jenkinsfile

The `Jenkinsfile` is a declarative pipeline for building this project.

### jenkins-docker-agent-template

The `jenkins-docker-agent-template.xml` file is a Jenkins XML job template for a Docker Agent Template.

It can be registered by running the `jenkins-setup-jobs.sh` script at the root of the project.

This template declares a Docker agent that will be provisioned by any job requiring a node with the below labels:

- docker-rhel-6.4-conan-gcc7 (single toolchain)
- docker && rhel6.4 && conan && gcc7 (single toolchain)
- docker && rhel6.4 && conan (all available toolchains)
 
## How to build as a standalone project

    git clone https://bitbucket.local/scm/infra/docker-images.git
    cd rhel/6.4/conan/gcc7
    docker build -t rhel-6.4-conan-gcc7 .
    docker login -u aallrd -p 'password' localhost:5000
    docker tag rhel-6.4-conan-gcc7 localhost:5000/aallrd/rhel-6.4-conan-gcc7:latest
    docker push localhost:5000/aallrd/rhel-6.4-conan-gcc7:latest
