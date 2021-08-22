#!/bin/sh

podman run --name otm -d --rm -v ./data:/var/lib/otm mytracks/opentopomap
