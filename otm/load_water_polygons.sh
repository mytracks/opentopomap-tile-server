#!/bin/bash

cd /external-data
if [ ! -d water-polygons-split-3857 ]; then
    if [ ! -f water-polygons-split-3857.zip ]; then
        wget https://osmdata.openstreetmap.de/download/water-polygons-split-3857.zip
    fi
    unzip water-polygons-split-3857.zip
    rm water-polygons-split-3857.zip
fi

if [ ! -d simplified-water-polygons-split-3857 ]; then
    if [ ! -f simplified-water-polygons-split-3857.zip ]; then
        wget https://osmdata.openstreetmap.de/download/simplified-water-polygons-split-3857.zip
    fi
    unzip simplified-water-polygons-split-3857.zip
    rm simplified-water-polygons-split-3857.zip
fi
