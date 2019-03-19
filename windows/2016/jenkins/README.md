# Windows 2016 jenkins images

## jenkins master configuration

We want the Jenkins master to orchestrate and dynamically provision Windows containers as Jenkins agents to run pipeline workload.
On your Jenkins master, install the below configuration:

- Install the plugin `Yet Another Docker Plugin`
- In `Manage Jenkins > Configure System` add `Yet Another Docker Plugin` as a **Cloud**
    - Configure the **Docker URL**: `tcp://172.21.33.59:2375`
	    - The REST API is disabled by default in the Docker installation on Windows server
        - Create/edit the file: `%ProgramData%\docker\config\daemon.json`
        - Insert: `{ "hosts": ["tcp://0.0.0.0:2375", "npipe://"] }`
        - Restart the Docker daemon: `restart-service docker`
        - Check that it works: `curl http://172.21.33.59:2375/info -UseBasicParsing`
    - Test that it is available by clicking on **Test Connection**
    `com.github.kostyasha.yad_docker_java.com.github.dockerjava.api.model.Version@693ad02[
    apiVersion=1.30
    arch=amd64
    gitCommit=e75fdb8
    goVersion=go1.8.3
    kernelVersion=10.0 14393 (14393.447.amd64fre.rs1_release_inmarket.161102-0100)
    operatingSystem=windows
    version=17.06.2-ee-6
    buildTime=2017-11-27T22:55:16.390883712+00:00
    experimental=<null>
    ]`
    - Add a new **Docker Template**
        - Set the name of the **Docker Image Name** that you want to use for this template
        - Set the **labels** that you want to use to identify this template in a pipeline
        - Set the **Pull strategy** to `Never` in order to use local images on the Docker server
        - Set the **Remote Filing System Root** to `C:\jenkins`
        - Keep all the other default settings
    - In your pipeline, reference the previously set labels in the `agent` section:
        `agent { node { label 'docker && windows' } }`

## slave

This folder hosts the dockerfile to create a base Jenkins slave image from the latest Windows Server Core 2016 docker image.