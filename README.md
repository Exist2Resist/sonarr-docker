# sonarr-docker

A minor bug in v3 exists until that is resolved latest will remain on v2. 

V3 of Sonarr running in a rhel8 container with gradheim python systemd replacement. 

For version 3 of Sonarr run:

`docker run -d --name sonarr3 -p 8989:8989 exist2resist/sonarr:v3`

For version 2 of Sonarr run:

`docker run -d --name sonarr3 -p 8989:8989 exist2resist/sonarr:v2`

or

`docker run -d --name sonarr3 -p 8989:8989 exist2resist/sonarr:latest`
