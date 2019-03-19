FROM localhost:5000/aallrd/windows-2016-jenkins-slave:latest

SHELL ["powershell.exe", "-ExecutionPolicy", "Bypass", "-Command"]

RUN Write-Host "Installing chocolatey packages..." ; \
    choco install cmake; \
    choco install python2; \
    choco install python3; \
    choco install swig; \
    Write-Host "Installing execnet" ; \
    C:\Python36\Scripts\pip.exe install --proxy=https://proxy:3128 execnet; \
    Write-Host "Installing Conan..." ; \
    C:\Python36\Scripts\pip.exe install --proxy=https://proxy:3128 conan==1.11.2; \
    Write-Host "Configuring Conan..." ; \
    C:\Python36\Scripts\conan.exe config install --verify-ssl=False https://conan.local/config; \
    (Get-Content ~/.conan/conan.conf -raw) -replace '~/.conan/data', ('C:/cdata' -f (Get-Date)) | Set-Content ~/.conan/conan.conf ; \
    Write-Host "Installing Maven..." ; \
    $root = join-path ${env:ProgramFiles(x86)} 'maven' ; \
    $m2_home = Join-Path $root apache-maven-3.0.5 ; \
    $m2_bin = Join-Path $m2_home 'bin' ; \
    $m2_repo = Join-Path $env:USERPROFILE '.m2' ; \
    Invoke-WebRequest -Uri 'http://apache.mediamirrors.org/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.zip' -OutFile (Join-Path $env:TEMP apache-maven-3.0.5-bin.zip) ; \
    Add-Type -AssemblyName System.IO.Compression.FileSystem ; \
    [System.IO.Compression.ZipFile]::ExtractToDirectory((Join-Path $env:TEMP apache-maven-3.0.5-bin.zip), $root) ; \
    New-Item -Path $root -type directory -Force | Out-Null ; \
    New-Item -Path $m2_repo -type directory -Force | Out-Null ; \
    [Environment]::SetEnvironmentVariable('M2_HOME', $m2_home, [EnvironmentVariableTarget]::Machine) ; \
    [Environment]::SetEnvironmentVariable('MAVEN_OPTS', '-Xms256m', [EnvironmentVariableTarget]::Machine) ; \
    [Environment]::SetEnvironmentVariable('M2', $m2_bin, [EnvironmentVariableTarget]::Machine) ; \
    [Environment]::SetEnvironmentVariable('M2_REPO', $m2_repo, [EnvironmentVariableTarget]::Machine) ; \
    Write-Host "Exporting PATH..." ; \
    [Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\Python36;C:\Python36\Scripts;C:\Program Files\CMake\bin' + ';' + $m2_bin, [EnvironmentVariableTarget]::Machine); \
    rm -Force (Join-Path $env:TEMP apache-maven-3.0.5-bin.zip) ; \
    Write-Host "[END]"
