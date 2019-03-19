pipelineJob('docker-images/rhel/6.4/rhel-6.4-java-oracle-jdk-1.8.0') {

    description('Build the RHEL 6.4 java Oracle JDK 1.8.0 image')

    parameters {
      booleanParam('force', false, 'Force the docker build by ignoring the cache')
    }

    triggers {
      parameterizedCron { parameterizedSpecification('H H */3 * * % force=true') }
      upstream('docker-images/rhel/6.4/rhel-6.4-base', 'SUCCESS')
    }

    definition {
        cps {
            script(readFileFromWorkspace('rhel/6.4/java/oracle-jdk/1.8.0/Jenkinsfile'))
            sandbox()
        }
    }

}
