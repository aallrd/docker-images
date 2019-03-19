// Create the folder tree in Jenkins
folder('docker-images') { description('Docker images maintained by aallrd.') }
folder('docker-images/rhel') { description('RHEL based Docker images.') }
folder('docker-images/rhel/6.4') { description('RHEL 6.4 based Docker images.') }
folder('docker-images/rhel/7.2') { description('RHEL 7.2 based Docker images.') }
folder('docker-images/windows') { description('Windows based Docker images.') }
folder('docker-images/windows/2016') { description('Windows 2016 based Docker images.') }
folder('docker-images/internal') { description('Internal tooling.') }
folder('docker-images/internal/build') { description('Internal build related tooling.') }

job("docker-images-seed-jobs") {

    description("Seed jobs for the INFRA docker images")
    authenticationToken("stash-post-receive-hook")
    label('linux')

    scm {
        git("https://bitbucket.local/scm/infra/docker-images.git", "master") { node ->
            node / gitConfigName("aallrd")
            node / gitConfigEmail("aallrd@github.com")
        }
    }

    steps {
        dsl {
            external("rhel/6.4/base/seed.groovy")
            external("rhel/6.4/grabby/seed.groovy")
            external("rhel/6.4/conan/base/seed.groovy")
            external("rhel/6.4/conan/gcc49/seed.groovy")
            external("rhel/6.4/conan/gcc6/seed.groovy")
            external("rhel/6.4/conan/gcc7/seed.groovy")
            external("rhel/6.4/java/oracle-jdk/1.8.0/seed.groovy")
            external("rhel/6.4/java/open-jdk/11/seed.groovy")
            external("rhel/6.4/maven/3.0.3-mx1/seed.groovy")
            external("rhel/6.4/maven/3.0.5/seed.groovy")
            external("rhel/6.4/maven/3.5.4/seed.groovy")
            external("rhel/6.4/maven/3.6.0/seed.groovy")
            external("rhel/7.2/base/seed.groovy")
            external("rhel/7.2/java/oracle-jdk/1.8.0/seed.groovy")
            external("rhel/7.2/java/open-jdk/11/seed.groovy")
            external("rhel/7.2/maven/3.0.5/seed.groovy")
            external("rhel/7.2/maven/3.5.4/seed.groovy")
            external("rhel/7.2/maven/3.6.0/seed.groovy")
            external("windows/2016/base/seed.groovy")
            external("windows/2016/jenkins/slave/seed.groovy")
            external("windows/2016/conan/base/seed.groovy")
            external("windows/2016/conan/msvc15/seed.groovy")
            external("internal/build/rpm/seed.groovy")
            external("internal/build/perforce/seed.groovy")
            external("internal/build/secondary/seed.groovy")
            external("internal/build/primary/seed.groovy")
            removeAction("DELETE")
            removeViewAction("DELETE")
        }
    }
}
