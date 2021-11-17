#!/bin/bash

echo "Loading SRTM data"

if [ ! -f /external-data/srtm_data/raw.tif ]; then
    mkdir -p /external-data/srtm_download
    cd /external-data/srtm_download
    wget -i /otm/srtm_url.list
    Unpack all zip files
    for zipfile in *.zip;do unzip -j -o "$zipfile" -d unpacked; done
    cd unpacked
    for hgtfile in *.hgt;do gdal_fillnodata.py $hgtfile $hgtfile.tif; done
    mkdir -p /external-data/srtm_data
    gdal_merge.py -n 32767 -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -o /external-data/srtm_data/raw.tif *.hgt.tif
fi

cd /external-data/srtm_data

if [ ! -f warp-1000.tif ]; then
    gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear -tr 1000 1000 raw.tif warp-1000.tif
fi
if [ ! -f warp-5000.tif ]; then
    gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear -tr 5000 5000 raw.tif warp-5000.tif
fi
if [ ! -f warp-500.tif ]; then
    gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear -tr 500 500 raw.tif warp-500.tif
fi
if [ ! -f warp-700.tif ]; then
    gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear -tr 700 700 raw.tif warp-700.tif
fi
if [ ! -f warp.tif ]; then
    gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear raw.tif warp.tif
fi
if [ ! -f warp-90.tif ]; then
    gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear -tr 90 90 raw.tif warp-90.tif
fi

if [ ! -f relief-5000.tif ]; then
    gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-5000.tif /usr/src/OpenTopoMap/mapnik/relief_color_text_file.txt relief-5000.tif
fi
if [ ! -f relief-500.tif ]; then
    gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-500.tif /usr/src/OpenTopoMap/mapnik/relief_color_text_file.txt relief-500.tif
fi
if [ ! -f hillshade-5000.tif ]; then
    gdaldem hillshade -z 7 -compute_edges -co COMPRESS=JPEG warp-5000.tif hillshade-5000.tif
fi
if [ ! -f hillshade-1000.tif ]; then
    gdaldem hillshade -z 7 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-1000.tif hillshade-1000.tif
fi
if [ ! -f hillshade-700.tif ]; then
    gdaldem hillshade -z 4 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-700.tif hillshade-700.tif
fi
if [ ! -f hillshade-500.tif ]; then
    gdaldem hillshade -z 4 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-500.tif hillshade-500.tif
fi
if [ ! -f hillshade-90.tif ]; then
    gdaldem hillshade -z 2 -co compress=lzw -co predictor=2 -co bigtiff=yes -compute_edges warp-90.tif hillshade-90.tif 
fi
if [ ! -f hillshade-30m-jpeg.tif ]; then
    gdaldem hillshade -z 5 -compute_edges -co BIGTIFF=YES -co TILED=YES -co COMPRESS=JPEG warp-90.tif hillshade-30m-jpeg.tif
fi
