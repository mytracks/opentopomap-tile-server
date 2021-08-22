#!/bin/bash

chown gis /var/lib/otm

sudo -u gis /otm/load_water_polygons.sh
sudo -u gis /otm/load_srtm.sh
#/otm/start_db.sh
#/otm/init_db.sh
