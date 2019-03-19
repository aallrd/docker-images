pipelineJob('docker-images/windows/2016/windows-2016-conan-msvc12') {

    description('Build the Windows Server Core 2016 conan image with the Visual Studio 2013 toolchain.')

    parameters {
      booleanParam('force', false, 'Force the docker build by ignoring the cache')
    }

    triggers {
      parameterizedCron { parameterizedSpecification('H H */3 * * % force=true') }
      upstream('docker-images/windows/2016/windows-2016-conan-base', 'SUCCESS')
    }
	
    definition {
        cps {
            script(readFileFromWorkspace('windows/2016/conan/msvc12/Jenkinsfile'))
            sandbox()
        }
    }

}
