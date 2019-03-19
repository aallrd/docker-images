# docker-images

## Jenkins master nodes

You need to configure two agents:

- Ubuntu 16.04 VM
    - Tools: `packer`, `docker`
    - Labels `linux`, `packer`, `docker`

- Windows Server 2016 VM
    - Tools: `docker`
    - Labels `windows`, `docker`
	
## Jenkins master setup

In order to automatically setup all the project's pipelines in Jenkins, you can use the `jenkins-setup-jobs.sh` script.

    Usage: jenkins-setup-jobs.sh [OPTIONS]
    -h|--help  : Print this helper.
    -U|--url   : The Jenkins URL. Default is: http://jenkins.local/aallrd.
    -u|--user  : The Jenkins user. Default is: aallard
    -t|--token : The users's Jenkins API token. Default is: ${API_TOKEN}

### mother-seed-job

The mother seed file `jenkins/mother-seed-job.xml` is a Jenkins freestyle job's XML, configured to load the DSL script `jenkins/mother_seed.groovy` when built.

### mother-seed

The mother seed file `jenkins/mother_seed.groovy` is a Jenkins DSL, it declares a job that will create/reload all the configured sub-projects DSLs seeds when built.

### seed

The seed files are located in each sub-projects. Like the mother seed file, they are jobs in the Jenkins DSL format.

These seeds files must be registered in the mother seed file `jenkins/mother_seed.groovy` in order to be automatically created/reloaded when the seed job is triggered.

A sub-project seed file is responsible for:

- loading its sub-project's Jenkinsfile in order to create a Jenkins pipeline job for this sub-project ;
- handling the dependency relationships between each sub-projects.

## Naming convention

We are following the below naming conventions in order to maintain consistency and order across our components.

### Docker

- A docker image is named after its path in the docker images repo.
  - Example, the code for the docker image `rhel-6.4-conan-base` is stored under `rhel/6.4/conan/base` in the docker images repo.

- Once a docker image is built, we push it twice on the nexus repo, with the `short commit ID` tag and with the `latest` tag.
  - It allows us to keep a commit based history for the Docker images, while still providing the most up to date image with the `latest` tag.

## Automation

### Server side

The `jenkins/mother_seed.groovy` file is configured with an Authentication Token that allows any script to trigger remotely the build of the seed job.

This build should be triggered after each `git push` on the `master` branch in order to reload all the sub-projects DSLs and to reflect any change that was committed.

It can be configured in the [hooks settings](https://bitbucket.local/projects/INFRA/repos/docker-images/settings/hooks) on the project's Stash page, with the *Http Request Post Receive Hook* plugin.

The configuration is a simple GET to the [Jenkins seed-job](http://jenkins.local/aallrd/job/docker-images-seed-jobs/build?token=stash-post-receive-hook) URL.

    curl -s XGET http://jenkins.local/aallrd/job/docker-images-seed-jobs/build?token=stash-post-receive-hook
