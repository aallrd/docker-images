pipelineJob('docker-images/rhel/6.4/rhel-6.4-conan-gcc6') {

    description('Build the RHEL 6.4 conan GCC 6 image')

    parameters {
      booleanParam('force', false, 'Force the docker build by ignoring the cache')
    }

    triggers {
      parameterizedCron { parameterizedSpecification('H H */3 * * % force=true') }
      upstream('docker-images/rhel/6.4/rhel-6.4-conan-base', 'SUCCESS')
    }

    definition {
        cps {
            script(readFileFromWorkspace('rhel/6.4/conan/gcc6/Jenkinsfile'))
            sandbox()
        }
    }

}
