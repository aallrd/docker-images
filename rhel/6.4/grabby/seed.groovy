pipelineJob('docker-images/rhel/6.4/rhel-6.4-grabby') {

    description('Build the Grabby test environment image')

    parameters {
      booleanParam('force', false, 'Force the docker build by ignoring the cache')
    }

    triggers {
      parameterizedCron { parameterizedSpecification('H H */3 * * % force=true') }
      upstream('docker-images/rhel/6.4/rhel-6.4-base', 'SUCCESS')
    }

    definition {
        cps {
            script(readFileFromWorkspace('rhel/6.4/grabby/Jenkinsfile'))
            sandbox()
        }
    }
}
