# internal-build-secondary

Build a docker image with the required tooling to build asecondary setup.

## Usage


### Help

```
docker run --rm -it localhost:5000/aallrd/internal-build-secondary:latest --help
---------------------------------------------------------------------------
Usage: run.sh [OPTIONS]
-----[ OPTIONS ]-----------------------------------------------------------
          -h|--help            : Print this helper.
          -v|--version         : The targeted version to build.
                                 Values: v3.1.build
          --no-sync            : Don't sync the targeted version sources. The source volume shoud already contain the synced sources. Useful when mounting the host filesystem.
          --git                : Use Bitbucket instead of Perforce to sync the targeted version sources. Expects the project name where the version (repo) is stored.
                                 Values: INFRA
          --shell              : Open an interactive shell instead of calling the build script.
          --                   : The arguments passed after this delimiter are evaluated by the targeted version build script.
                                 Values: -- --help
---------------------------------------------------------------------------
Report bugs to aallrd@github
---------------------------------------------------------------------------
```

### Build a version synced on the host

Assuming the version is synced locally in the _/src/new_ directory.

```
# Start the build
docker run --rm -ti \
  -v /src/new:/src/new \
  -v cpp-build-data:/genoff.new \
  localhost:5000/aallrd/internal-build-secondary:latest \
  --version v3.1.build \
  --no-sync \
  -- \
  --no-test \
  --no-packaging \
  --no-addons
```

### Open a build shell for a version synced on the host

Assuming the version is synced locally in the _/src/new_ directory.

```
# Start the build
docker run --rm -ti \
  -v /src/new:/src/new \
  -v cpp-build-data:/genoff.new \
  localhost:5000/aallrd/internal-build-secondary:latest \
  --version v3.1.build \
  --no-sync \
  --shell
```

### Sync and build using Perforce

```
# Create the perforce-data volume to store the Perforce credentials and configuration
docker run --rm -ti \
  -v perforce-data:/home/jenkins \
  localhost:5000/aallrd/internal-build-perforce:latest \
  --user aallard

# Start the build
docker run --rm -ti \
  -v perforce-data:/home/jenkins \
  -v cpp-src-data:/src/new \
  -v cpp-build-data:/genoff.new \
  localhost:5000/aallrd/internal-build-secondary:latest \
  --version v3.1.build \
  -- \
  --no-test \
  --no-packaging \
  --no-addons
```

### Sync and build using Git

```
# Start the build
docker run --rm -ti \
  -v cpp-src-data:/src/new \
  -v cpp-build-data:/genoff.new \
  localhost:5000/aallrd/internal-build-secondary:latest \
  --version v3.1.build \
  --bitbucket INFRA \
  -- \
  --no-test \
  --no-packaging \
  --no-addons
```

### Tailing the build logs

```
docker run --rm -it \
  -v cpp-build-data:/genoff.new \
  busybox \
  tail -f /genoff.new/v3.1.build/logs/build_compall.log
```

## Build requirements

- Ubuntu 16.04.3 LTS
- docker (Docker version 17.05.0-ce, build 89658be)

## How to build as a standalone project

    git clone https://bitbucket.local/scm/infra/docker-images.git
    cd internal/build/secondary
    docker build -t internal-build-secondary .
    docker login -u aallrd -p 'password' localhost:5000
    docker tag internal-build-secondary localhost:5000/aallrd/internal-build-secondary:latest
    docker push localhost:5000/aallrd/internal-build-secondary:latest

## Jenkins integration

### seed DSL file

The `seed.groovy` file is a Jenkins DSL file that creates a pipeline Job from the `Jenkinsfile`.

It must be registered in the `jenkins/mother_seed.groovy` file in order to be automatically created during the seed jobs creation. 

### Jenkinsfile

The `Jenkinsfile` is a declarative pipeline for building this project.
