#!/bin/bash

if [ -f /var/lib/otm/osm-import-complete ]; then
    echo "Skipping OSM data import: already imported"
    exit 0
fi

echo "Importing OSM data"

osm2pgsql --slim -d gis -C 12000 --number-processes 10 --style /usr/src/OpenTopoMap/mapnik/osm2pgsql/opentopomap.style /var/lib/otm/osm_download/planet-latest.osm.bz2

touch /var/lib/otm/osm-import-complete
