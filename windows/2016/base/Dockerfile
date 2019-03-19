FROM localhost:5000/aallrd/windowsservercore:10.0.14393.2007

SHELL ["powershell.exe", "-ExecutionPolicy", "Bypass", "-Command"]

ENV chocolateyUseWindowsCompression false
ENV chocolateyProxyLocation 'http://proxy:3128'

COPY scripts/chocolatey.ps1 C:/chocolatey.ps1

# Install Chocolatey
RUN iex C:/chocolatey.ps1; \
    choco feature disable --name showDownloadProgress; \
    choco feature enable --name allowGlobalConfirmation; \
    choco install git

# Configure git
RUN git config --global user.name "docker-windows-2016-base" ; \
    git config --global user.email "docker-windows-2016-base@internal.com"; \
    git config --global core.autocrlf false
