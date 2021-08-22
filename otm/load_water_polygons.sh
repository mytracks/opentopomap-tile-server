#!/bin/bash

if [ -f /var/lib/otm/water-polygons-import-complete ]; then
    echo "Skipping water polgons import: data already imported"
    exit 0
fi

cd /var/lib/otm && mkdir -p mapnik/data
wget https://osmdata.openstreetmap.de/download/simplified-water-polygons-split-3857.zip
wget https://osmdata.openstreetmap.de/download/water-polygons-split-3857.zip
unzip water-polygons-split-3857.zip
unzip simplified-water-polygons-split-3857.zip

touch /var/lib/otm/water-polygons-import-complete
