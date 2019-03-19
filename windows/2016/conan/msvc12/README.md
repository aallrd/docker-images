# windows-2016-conan-msvc12

Build a conan image of Windows Server Core 2016 with the Visual Studio 2013 toolchain installed.

## Requirements

- Ubuntu 16.04.3 LTS
- docker (Docker version 17.05.0-ce, build 89658be)

## MSVC details

- Windows SDK version 10.0.16299.0 to target Windows 10.0.14393
- MSVC 18.0.40629.0
- Microsoft (R) Build Engine, version 12.0.40629.0

## Conan default profile

    [build_requires]
    [settings]
    os=Windows
    os_build=Windows
    arch=x86_64
    arch_build=x86_64
    compiler=Visual Studio
    compiler.version=12
    build_type=Release
    [options]
    [env]

## Visual Studio 2013 Update 5 package

    wget 'http://data.local/iso/windows/en_visual_studio_professional_2013_with_update_5_x86_dvd_6815752.zip' -OutFile .
	
## Jenkins integration

### seed DSL file

The `seed.groovy` file is a Jenkins DSL file that creates a pipeline Job from the `Jenkinsfile`.

It must be registered in the `jenkins/mother_seed.groovy` file in order to be automatically created during the seed jobs creation. 

### Jenkinsfile

The `Jenkinsfile` is a declarative pipeline for building this project.

## How to build as a standalone project

    git clone https://bitbucket.local/scm/infra/docker-images.git
    cd windows/2016/conan/msvc12
    docker build . -t windows-2016-conan-msvc12 -m 2GB
	docker image list
      REPOSITORY                    TAG                    IMAGE ID            CREATED             SIZE
      windows-2016-conan-msvc12       latest                 16962939a1c9        1 hours ago        11.6GB
    docker login -u aallrd -p 'password' localhost:5000
    docker tag windows-2016-conan-msvc15 localhost:5000/aallrd/windows-2016-conan-msvc12:latest
    docker push localhost:5000/aallrd/windows-2016-conan-msvc12:latest
