FROM microsoft/nanoserver
LABEL maintainer="peter@pouliot.net"
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV SYNCTHING_VERSION 0.14.44
ENV SYNCTHING_DOWNLOAD_URL https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/syncthing-windows-amd64-v${SYNCTHING_VERSION}.zip
ENV all_proxy ""
COPY VERSION VERSION
COPY Dockerfile Dockerfile
RUN Write-Host ('Downloading {0} ...' -f $env:SYNCTHING_DOWNLOAD_URL); \
    Invoke-WebRequest -Uri $env:SYNCTHING_DOWNLOAD_URL -OutFile c:\syncthing-windows-amd64.zip
RUN \
	Write-Host 'Expanding ...'; \
    Expand-Archive -Path c:\syncthing-windows-amd64.zip -DestinationPath C:\ -Force ;
RUN \
    Remove-Item -Path c:\syncthing-windows-amd64.zip -Confirm:$False; \
    Rename-Item -Path c:\syncthing-windows-amd64-v$env:SYNCTHING_VERSION -NewName syncthing 
RUN \
    $newPath = ('C:\syncthing;{0}' -f $env:PATH); \
    Write-Host ('Updating PATH: {0}' -f $newPath); \
    setx /M PATH $newPath;
RUN @('c:/syncthing','c:/syncthing/data','c:/syncthing/config')| foreach { New-Item -Path $_ -ItemType Directory -Force }
VOLUME c:/syncthing/config
VOLUME c:/syncthing/data
EXPOSE 8384 22000 21027/UDP
RUN c:/syncthing/syncthing.exe -no-console -no-browser -gui-address="http://0.0.0.0:8384" -generate=c:/syncthing/config -home=c:/syncthing/config
ENTRYPOINT c:/syncthing/syncthing.exe -no-console -no-browser -gui-address="http://0.0.0.0:8384" -home=c:/syncthing/config

