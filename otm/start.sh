#!/bin/bash

/otm/start_db.sh  || exit -1

sudo -u gis /otm/load_water_polygons.sh || exit -1
sudo -u gis /otm/load_srtm.sh || exit -1
sudo -u gis /otm/load_osm.sh || exit -1

sudo -u gis /otm/import_contours.sh || exit -1
sudo -u gis /otm/import_osm.sh || exit -1
sudo -u gis /otm/update_lowzoom.sh || exit -1
sudo -u gis /otm/update_saddles.sh || exit -1
sudo -u gis /otm/update_db.sh || exit -1
sudo -u gis /otm/update_isolations.sh || exit -1
sudo -u gis /otm/update_parking.sh || exit -1

service apache2 start || exit -1                        

# su -c 'tirex-backend-manager --debug' gis &
# su -c 'tirex-master -f --debug' gis

# Run while handling docker stop's SIGTERM
stop_handler() {
    kill -TERM "$child"
}
trap stop_handler SIGTERM
    
su -c 'tirex-backend-manager' gis || exit -1
su -c 'tirex-master -f' gis &
child=$!
wait "$child"

/otm/stop_db.sh || exit -1
service apache2 stop || exit -1
