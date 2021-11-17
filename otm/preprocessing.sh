#!/bin/bash

if [ -f /external-data/preprocessing-complete ]; then
    echo "Skipping preprocessing: already done"
    exit 0
fi

echo "Preprocessing"

cd /usr/src/OpenTopoMap/mapnik/tools/
psql gis < arealabel.sql
./update_lowzoom.sh

sed -i 's#mapnik/dem/dem-srtm.tiff#/external-data/srtm_data/raw.tif#g' update_saddles.sh
sed -i 's#~/OpenTopoMap#/usr/src/OpenTopoMap#g' update_saddles.sh
sed -i 's#mapnik/dem/dem-srtm.tiff#/external-data/srtm_data/raw.tif#g' update_isolations.sh

./update_saddles.sh
./update_isolations.sh

psql gis < stationdirection.sql
psql gis < viewpointdirection.sql
psql gis < pitchicon.sql

touch /external-data/preprocessing-complete
