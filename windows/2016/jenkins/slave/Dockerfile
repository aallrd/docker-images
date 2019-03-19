FROM localhost:5000/aallrd/windows-2016-base:latest

SHELL ["powershell.exe", "-ExecutionPolicy", "Bypass", "-Command"]

ENV JAVA_HOME C:\\jdk1.8.0_131
ENV JENKINS_HOME c:\\jenkins

# Install Java
RUN [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials ; \
	$client = New-Object System.Net.WebClient ; \
	$cookie = 'oraclelicense=accept-securebackup-cookie' ; \
	$client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie) ; \
	$client.downloadFile('http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-windows-x64.exe', (Join-Path $env:TEMP jdk-8u161-windows-x64.exe)) ; \
	Start-Process -Filepath (Join-Path $env:TEMP jdk-8u161-windows-x64.exe) -passthru -wait -argumentlist "/s,INSTALLDIR=$env:JAVA_HOME,/L,install64.log" ; \
	Remove-Item -Force (Join-Path $env:TEMP jdk-8u161-windows-x64.exe) ; \
	$env:PATH = $env:JAVA_HOME + '\\bin;' + $env:PATH ; \
	[Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine) ; \
	[Environment]::SetEnvironmentVariable('JAVA_HOME', $env:JENKINS_HOME, [EnvironmentVariableTarget]::Machine)

# Create Jenkins home directory
RUN mkdir $env:JENKINS_HOME

WORKDIR $JENKINS_HOME