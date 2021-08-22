#!/bin/bash

if [ -f /var/lib/otm/db-init-complete ]; then
    echo "Skipping database init: already initialized"
    exit 0
fi

echo "Initializing database"

if [ ! -f /var/lib/postgresql/9.5/main/PG_VERSION ]; then
    sudo -u postgres /usr/lib/postgresql/9.5/bin/pg_ctl -D /var/lib/postgresql/9.5/main/ initdb -o "--locale C.UTF-8"
fi

sudo -u postgres createuser --createdb gis -s
sudo -u gis createdb gis
sudo -u gis psql -d gis -c 'CREATE EXTENSION postgis;'
sudo -u gis createdb contours
sudo -u gis psql -d contours -c 'CREATE EXTENSION postgis;'

touch /var/lib/otm/db-init-complete
