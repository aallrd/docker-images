pipelineJob('docker-images/windows/2016/windows-2016-jenkins-slave') {

    description('Build a Jenkins slave docker image')

    parameters {
      booleanParam('force', false, 'Force the docker build by ignoring the cache')
    }

    triggers {
      parameterizedCron { parameterizedSpecification('H H */3 * * % force=true') }
      upstream('docker-images/windows/2016/windows-2016-base', 'SUCCESS')
    }

    definition {
        cps {
            script(readFileFromWorkspace('windows/2016/jenkins/slave/Jenkinsfile'))
            sandbox()
        }
    }

}
