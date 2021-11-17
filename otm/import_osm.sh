#!/bin/bash

if [ -f /var/lib/mod_tile/planet-import-complete ]; then
    echo "Skipping OSM data import: already imported"
    exit 0
fi

echo "Importing OSM data"

dropdb --if-exists gis || exit -1
createdb gis || exit -1
psql -d gis -c 'CREATE EXTENSION postgis;' || exit -1

osm2pgsql --slim -d gis -C 12000 --number-processes 10 --style /usr/src/OpenTopoMap/mapnik/osm2pgsql/opentopomap.style --flat-nodes=/external-data/osm_download/flat_nodes --drop /external-data/osm_download/planet-latest.osm.pbf || exit -1

#osm2pgsql --slim -d gis -C 12000 --number-processes 10 --style /usr/src/OpenTopoMap/mapnik/osm2pgsql/opentopomap.style /external-data/osm_download/germany-latest.osm.pbf || exit -1

touch /var/lib/mod_tile/planet-import-complete
