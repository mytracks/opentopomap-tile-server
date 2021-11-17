#!/bin/sh

podman build -t docker.io/mytracks/opentopomap-tile-server:20.04 -f Dockerfile-20.04 .
