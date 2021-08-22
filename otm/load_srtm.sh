#!/bin/bash

if [ -f /var/lib/otm/srtm-import-complete ]; then
    echo "Skipping SRTM import: data already imported"
    exit 0
fi

echo "Loading SRTM data"

mkdir -p /var/lib/otm/srtm_download
cd /var/lib/otm/srtm_download
wget -i /otm/srtm_url.list
Unpack all zip files
for zipfile in *.zip;do unzip -j -o "$zipfile" -d unpacked; done
cd unpacked
for hgtfile in *.hgt;do gdal_fillnodata.py $hgtfile $hgtfile.tif; done
mkdir -p /var/lib/otm/srtm_data
gdal_merge.py -n 32767 -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -o /var/lib/otm/srtm_data/raw.tif *.hgt.tif

cd /var/lib/otm/srtm_data
gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear -tr 1000 1000 raw.tif warp-1000.tif
gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear -tr 5000 5000 raw.tif warp-5000.tif
gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear -tr 500 500 raw.tif warp-500.tif
gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear -tr 700 700 raw.tif warp-700.tif
gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear -tr 90 90 raw.tif warp-90.tif

gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-5000.tif /usr/src/OpenTopoMap/mapnik/relief_color_text_file.txt relief-5000.tif
gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-500.tif /usr/src/OpenTopoMap/mapnik/relief_color_text_file.txt relief-500.tif
gdaldem hillshade -z 7 -compute_edges -co COMPRESS=JPEG warp-5000.tif hillshade-5000.tif
gdaldem hillshade -z 7 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-1000.tif hillshade-1000.tif
gdaldem hillshade -z 4 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-700.tif hillshade-700.tif
gdaldem hillshade -z 2 -co compress=lzw -co predictor=2 -co bigtiff=yes -compute_edges warp-90.tif hillshade-90.tif 
gdal_translate -co compress=JPEG -co bigtiff=yes -co tiled=yes hillshade-90.tif hillshade-90-jpeg.tif
phyghtmap --max-nodes-per-tile=0 -s 10 -0 --pbf warp-90.tif

mv lon-*.osm.pbf contours.pbf

touch /var/lib/otm/srtm-import-complete
