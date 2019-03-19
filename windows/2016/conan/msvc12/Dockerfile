FROM localhost:5000/aallrd/windows-2016-conan-base:latest as intermediate
RUN mkdir 'C:/tmp' ; mkdir 'C:/vs2013'
COPY en_visual_studio_professional_2013_with_update_5_x86_dvd_6815752.zip C:/tmp/vs2013.zip
RUN Expand-Archive C:/tmp/vs2013.zip -DestinationPath C:/vs2013/

FROM localhost:5000/aallrd/windows-2016-conan-base:latest
RUN mkdir 'C:/vs2013' | Out-Null
COPY --from=intermediate C:/vs2013/ C:/vs2013/
RUN & C:\vs2013\vs_professional.exe /Quiet /NoRestart /NoWeb /NoRefresh /AdminFile 'C:/vs2013/AdminDeployment.xml' /Log $env:temp/vs.log ; \
	Write-Host 'Waiting 3600s for vs_professional to finish...' ; \
	Start-Sleep -s 3600 ; \
	Write-Host 'Backing up installation logs...' ; \
	mkdir 'C:/logs' | Out-Null ; Copy-Item -Path $env:temp/*.log -Destination C:/logs
RUN Write-Host 'Cleaning...' ; \
	Remove-Item -Path C:/vs2013 -Force -Recurse