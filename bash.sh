#!/bin/sh

podman run --name otm_bash --rm -ti -v ./data:/var/lib/otm -v ./db:/var/lib/postgresql/9.5/main mytracks/opentopomap-tile-server bash
