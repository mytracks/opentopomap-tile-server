#!/bin/bash

if [ -f /external-data/db-update-complete ]; then
    echo "Skipping db data update: data already updated"
    exit 0
fi

echo "Update db data"

psql gis < /usr/src/OpenTopoMap/mapnik/tools/stationdirection.sql
psql gis < /usr/src/OpenTopoMap/mapnik/tools/viewpointdirection.sql
psql gis < /usr/src/OpenTopoMap/mapnik/tools/pitchicon.sql

touch /external-data/db-update-complete
