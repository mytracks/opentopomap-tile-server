#!/bin/sh

# -v ./data:/external-data -v ./db:/db 
podman run --name otm_bash --rm -ti docker.io/mytracks/opentopomap-tile-server:20.04 bash
