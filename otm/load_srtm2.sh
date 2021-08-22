#!/bin/bash

if [ -f /var/lib/otm/srtm2-import-complete ]; then
    echo "Skipping SRTM2 import: data already imported"
    exit 0
fi

echo "Loading SRTM2 data"


cd /usr/src/OpenTopoMap/mapnik
sed -i 's#<Parameter name="table">(SELECT way,ele FROM contours) AS contours </Parameter>##g' opentopomap.xml

cd /var/lib/otm/srtm_data

gdaldem hillshade -z 5 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-500.tif hillshade-500.tif
gdaldem hillshade -z 5 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-90.tif hillshade-30m-jpeg.tif

mkdir /usr/src/OpenTopoMap/mapnik/dem
cd /usr/src/OpenTopoMap/mapnik/dem
ln -s /var/lib/otm/srtm_data/*.tif .

touch /var/lib/otm/srtm2-import-complete
