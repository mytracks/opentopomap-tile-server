#!/bin/bash

if [ -f /var/lib/otm/load-osm-complete ]; then
    echo "Skipping loading OSm data: already loaded"
    exit 0
fi

echo "Loading ODM data"

mkdir -p /var/lib/otm/osm_download
cd /var/lib/otm/osm_download

wget https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/planet/planet-latest.osm.bz2

touch /var/lib/otm/load-osm-complete
