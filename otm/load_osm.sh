#!/bin/bash

if [ -f /external-data/load-osm-complete ]; then
    echo "Skipping loading OSM data: already loaded"
    exit 0
fi

echo "Loading OSM data"

mkdir -p /external-data/osm_download
cd /external-data/osm_download

wget https://ftp.fau.de/osm-planet/pbf/planet-latest.osm.pbf

touch /external-data/load-osm-complete
