pipelineJob('docker-images/windows/2016/windows-2016-base') {

    description('Build the Windows Server Core 2016 base image')

    parameters {
      booleanParam('force', false, 'Force the docker build by ignoring the cache')
    }

    triggers {
      parameterizedCron { parameterizedSpecification('H H */3 * * % force=true') }
    }

    definition {
        cps {
            script(readFileFromWorkspace('windows/2016/base/Jenkinsfile'))
            sandbox()
        }
    }

}
