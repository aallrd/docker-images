pipelineJob('docker-images/rhel/7.2/rhel-7.2-java-open-jdk-11') {

    description('Build the RHEL 7.2 java Oracle JDK 11 image')

    parameters {
      booleanParam('force', false, 'Force the docker build by ignoring the cache')
    }

    triggers {
      parameterizedCron { parameterizedSpecification('H H */3 * * % force=true') }
      upstream('docker-images/rhel/7.2/rhel-7.2-base', 'SUCCESS')
    }

    definition {
        cps {
            script(readFileFromWorkspace('rhel/7.2/java/open-jdk/11/Jenkinsfile'))
            sandbox()
        }
    }

}
