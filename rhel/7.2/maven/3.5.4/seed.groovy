pipelineJob('docker-images/rhel/7.2/rhel-7.2-maven-3.5.4') {

    description('Build the RHEL 7.2 Maven 3.5.4 image.')

    parameters {
      booleanParam('force', false, 'Force the docker build by ignoring the cache')
    }

    triggers {
      parameterizedCron { parameterizedSpecification('H H */3 * * % force=true') }
      upstream('docker-images/rhel/7.2/rhel-7.2-java-oracle-jdk-1.8.0', 'SUCCESS')
    }

    definition {
        cps {
            script(readFileFromWorkspace('rhel/7.2/maven/3.5.4/Jenkinsfile'))
            sandbox()
        }
    }

}
