# internal-build-perforce

Build a docker image with the required tooling to build aperforce setup.

## Usage

```
# Create a named volume "perforce-data" holding the perforce login and client information
docker run --rm -ti -v perforce-data:/home/jenkins localhost:5000/aallrd/internal-build-perforce:latest --user aallard
```

## Build requirements

- Ubuntu 16.04.3 LTS
- docker (Docker version 17.05.0-ce, build 89658be)

## How to build as a standalone project

    git clone https://bitbucket.local/scm/infra/docker-images.git
    cd internal/build/perforce
    docker build -t internal-build-perforce .
    docker login -u aallrd -p 'password' localhost:5000
    docker tag internal-build-perforce localhost:5000/aallrd/internal-build-perforce:latest
    docker push localhost:5000/aallrd/internal-build-perforce:latest

## Jenkins integration

### seed DSL file

The `seed.groovy` file is a Jenkins DSL file that creates a pipeline Job from the `Jenkinsfile`.

It must be registered in the `jenkins/mother_seed.groovy` file in order to be automatically created during the seed jobs creation. 

### Jenkinsfile

The `Jenkinsfile` is a declarative pipeline for building this project.
