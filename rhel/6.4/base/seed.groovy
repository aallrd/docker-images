pipelineJob('docker-images/rhel/6.4/rhel-6.4-base') {

    description('Build the RHEL 6.4 base image')

    definition {
        cps {
            script(readFileFromWorkspace('rhel/6.4/base/Jenkinsfile'))
            sandbox()
        }
    }

}
