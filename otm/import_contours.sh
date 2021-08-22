#!/bin/bash

if [ -f /var/lib/otm/contours-import-complete ]; then
    echo "Skipping contours import: already imported"
    exit 0
fi

echo "Importing contours"

osm2pgsql --slim -d contours -C 12000 --number-processes 10 --style /usr/src/OpenTopoMap/mapnik/osm2pgsql/contours.style /var/lib/otm/srtm_data/contours.pbf

touch /var/lib/otm/contours-import-complete
