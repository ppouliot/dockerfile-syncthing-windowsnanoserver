FROM microsoft/nanoserver
LABEL maintainer="peter@pouliot.net"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV SYNTHING_VERSION 0.14.44
ENV all_proxy ""
RUN \
    # Install SyncThing
    Invoke-WebRequest -Uri https://github.com/syncthing/syncthing/releases/download/vSYNCTHING_VERSION/syncthing-windows-amd64-vSYNCTHING_VERSION.zip \
    Expand-Archive -Path C:\syncthing-windows-amd64-vSYNCTHING_VERSION.zip -DestinationPath C:\ -Force \
    Remove-Item -Path C:\syncthing-windows-amd64-vSYNCTHING_VERSION.zip -Confirm:$False; \
    Rename-Item -Path C:\syncthing-windows-amd64-vSYNCTHING_VERSION -NewName syncthing 
# PATH isn't actually set in the Docker image, so we have to set it from within the container
RUN $newPath = ('C:\syncthing;{0}' -f $env:PATH); \
        Write-Host ('Updating PATH: {0}' -f $newPath); \
# Nano Server does not have "[Environment]::SetEnvironmentVariable()"
        setx /M PATH $newPath;`
RUN $SyncthingDirs = "c:\\syncthing\\config","c:\\syncthing\\data" \
    New-Item -ItemType directory $SyncthingDirs

VOLUME c:\\syncthing\\config
VOLUME c:\\syncthing\\data
EXPOSE 8384 22000 21027/UDP
RUN c:\\syncthing\\syncthing.exe -no-browser -generate=c:\\syncthing\\config -home=c:\\syncthing\\config -no-console
ENTRYPOINT c:\\syncthing\\syncthing.exe -no-browser -home=c:\\syncthing\\config
