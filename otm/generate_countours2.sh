#!/bin/sh

longitude=$1

gdal_merge.py -n 32767 -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -o $longitude.tif [NS][0-9][0-9]$longitude.hgt.tif

gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear $longitude.tif $longitude.warp.tif

prefix=`openssl rand -hex 12`
phyghtmap --max-nodes-per-tile=0 -s 10 -0 --output-prefix=$prefix --pbf $longitude.warp.tif
mv $prefix*lon*pbf $longitude.pbf

rm $longitude.tif $longitude.warp.tif