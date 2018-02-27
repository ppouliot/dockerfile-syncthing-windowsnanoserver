# syncthing-windowsnanoserver

A containerized deployment of [SyncThing](https://syncthing.net) running inside a Windows Container.

## Windows NanoServer

A [Dockerfile](./Dockerfile) for WindowsNano Server which uses the latest release of [SyncThing](https://syncthing.net).
It pulls SyncThing from the latest Github Release via Powershell, installs and executes with a data volume at c:\syncthing\data.
 
## WindowsServerCore

A containerized deployment of [SyncThing](https://syncthing.net) running inside a Windows Core Container.
A [Dockerfile](./Dockerfile.windowsservercore) for installing SyncThing via Chocolatey on a Windows Server Core container.
The latest Package available via Chocolatey Repositories is installed and executed with a data Volume at c:\syncthing\data.

## Docker-compose.yml
A [docker-compose.yml](./docker-compose.yml) file exists and can be used to run the container as a service.