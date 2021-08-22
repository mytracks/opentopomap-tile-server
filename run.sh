#!/bin/sh

podman run --name otm -d --rm -v ./data:/var/lib/otm -v ./db:/var/lib/postgresql/9.5/main mytracks/opentopomap-tile-server
