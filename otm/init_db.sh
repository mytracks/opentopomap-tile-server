#!/bin/bash

if [ -f /var/lib/otm/db-init-complete ]; then
    echo "Skipping database init: already initialized"
    exit 0
fi

echo "Initializing database"

sudo -u postgres createuser --createdb gis -s
sudo -u gis createdb gis
sudo -u gis psql -d gis -c 'CREATE EXTENSION postgis;'
sudo -u gis createdb contours
sudo -u gis psql -d contours -c 'CREATE EXTENSION postgis;'

touch /var/lib/otm/db-init-complete
