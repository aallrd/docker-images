pipelineJob('docker-images/rhel/6.4/rhel-6.4-maven-3.5.4') {

    description('Build the RHEL 6.4 Maven 3.5.4 image.')

    parameters {
      booleanParam('force', false, 'Force the docker build by ignoring the cache')
    }

    triggers {
      parameterizedCron { parameterizedSpecification('H H */3 * * % force=true') }
      upstream('docker-images/rhel/6.4/rhel-6.4-java-oracle-jdk-1.8.0', 'SUCCESS')
    }

    definition {
        cps {
            script(readFileFromWorkspace('rhel/6.4/maven/3.5.4/Jenkinsfile'))
            sandbox()
        }
    }

}
