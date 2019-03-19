pipelineJob('docker-images/rhel/7.2/rhel-7.2-base') {

    description('Build the RHEL 7.2 base image')

    definition {
        cps {
            script(readFileFromWorkspace('rhel/7.2/base/Jenkinsfile'))
            sandbox()
        }
    }

}
