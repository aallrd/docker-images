pipelineJob('docker-images/rhel/6.4/rhel-6.4-maven-3.6.0') {

    description('Build the RHEL 6.4 Maven 3.6.0 image.')

    parameters {
      booleanParam('force', false, 'Force the docker build by ignoring the cache')
    }

    triggers {
      parameterizedCron { parameterizedSpecification('H H */3 * * % force=true') }
      upstream('docker-images/rhel/6.4/rhel-6.4-java-oracle-jdk-1.8.0', 'SUCCESS')
    }

    definition {
        cps {
            script(readFileFromWorkspace('rhel/6.4/maven/3.6.0/Jenkinsfile'))
            sandbox()
        }
    }

}
