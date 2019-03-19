FROM localhost:5000/aallrd/windows-2016-conan-base:latest

RUN choco install visualstudio2017enterprise; \
    choco install visualstudio2017-workload-nativedesktop; \
    cd ~\.conan\profiles; \
    cmd /c mklink .\default .\windows-msvc15

# Cannot install the Windows81SDK with chocolatey: https://github.com/jberezanski/ChocolateyPackages/issues/27
RUN & 'C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe' \
    modify --quiet --norestart --nocache \
    --installPath 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise' \
    --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Win81; \
    Write-Host 'Waiting for vs_installer.exe to finish...'; \
    Wait-Process -Name vs_installer
