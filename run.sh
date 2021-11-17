#!/bin/sh

podman rm -f otm
podman run --name otm -d -p 8080:80 -v ./data:/external-data -v ./db:/db -v ./tiles:/var/lib/mod_tile -v /osm-import:/osm-import docker.io/mytracks/opentopomap-tile-server:test
#podman run --name otm --rm -ti -p 8080:80 -v ./data:/var/lib/otm -v ./db:/db -v ./tiles:/var/lib/mod_tile -v /osm-import:/osm-import docker.io/mytracks/opentopomap-tile-server:test
