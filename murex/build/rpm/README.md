# internal-build-rpm

Build a RPM builder docker image from the latest RHEL 6.4 minimal docker image. 

## Usage

### Help

```
docker run --rm -it localhost:5000/aallrd/internal-build-rpm:latest --help
---------------------------------------------------------------------------
Usage: run.sh [OPTIONS]
-----[ OPTIONS ]-----------------------------------------------------------
          -h|--help            : Print this helper.
          -b|--build           : Build the RPM from the spec file.
---------------------------------------------------------------------------
Report bugs to aallrd@github
---------------------------------------------------------------------------
```

### Build the RPM files

Two mandatory options:
* **--volume $(pwd):/specs**: Mount the RPM spec file in the RPM build container.
* **--volume $(pwd):/output**: Mount the RPM output directory in the RPM build container.

```
docker run --rm -it --volume $(pwd):/specs --volume $(pwd):/output localhost:5000/aallrd/internal-build-rpm:latest --build
```

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
    cd internal/build/rpm
    docker build -t internal-build-rpm .
    docker login -u aallrd -p 'password' localhost:5000
    docker tag internal-build-rpm localhost:5000/aallrd/internal-build-rpm:latest
    docker push localhost:5000/aallrd/internal-build-rpm:latest
