pipelineJob('docker-images/internal/build/internal-build-perforce') {

    description('Build thebuild perforce image.')

    parameters {
      booleanParam('force', false, 'Force the docker build by ignoring the cache')
    }

    triggers {
      parameterizedCron { parameterizedSpecification('H H */3 * * % force=true') }
      upstream('docker-images/rhel/6.4/rhel-6.4-maven-3.0.5', 'SUCCESS')
    }

    definition {
        cps {
            script(readFileFromWorkspace('internal/build/perforce/Jenkinsfile'))
            sandbox()
        }
    }

}
