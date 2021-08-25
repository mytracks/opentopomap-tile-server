#!/bin/bash

chown gis /var/lib/otm

sudo -u gis /otm/load_water_polygons.sh
sudo -u gis /otm/load_srtm.sh
sudo -u gis /otm/load_osm.sh

/otm/start_db.sh
/otm/init_db.sh

sudo -u gis /otm/import_contours.sh
sudo -u gis /otm/import_osm.sh
sudo -u gis /otm/preprocessing.sh

/otm/stop_db.sh