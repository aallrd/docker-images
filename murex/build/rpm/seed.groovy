pipelineJob('docker-images/internal/build/internal-build-rpm') {

    description('Build the RHEL 6.4 RPM builder image')

    parameters {
      booleanParam('force', false, 'Force the docker build by ignoring the cache')
    }

    triggers {
      parameterizedCron { parameterizedSpecification('H H */3 * * % force=true') }
      upstream('docker-images/rhel/6.4/rhel-6.4-base', 'SUCCESS')
    }

    definition {
        cps {
            script(readFileFromWorkspace('internal/build/rpm/Jenkinsfile'))
            sandbox()
        }
    }
}
