#!/bin/bash

if [ -f /external-data/contours-import-complete ]; then
    echo "Skipping contours import: already imported"
    exit 0
fi

echo "Importing contours"

dropdb --if-exists contours
createdb contours || exit -1
psql -d contours -c 'CREATE EXTENSION postgis;' || exit -1

cd /external-data/srtm_download/unpacked

rm -f contours.parallel
startid=10000000
#for hgttiffile in N4[7-9]E00[6-9].hgt.tif N5[0-2]E00[6-9].hgt.tif N4[7-9]E010.hgt.tif N5[0-2]E010.hgt.tif
for hgttiffile in *.hgt.tif
do
    echo "./generate_contours.sh $hgttiffile $startid" >> contours.parallel
    startid=$(( startid + 100000000 ))
done

parallel -j 8 -a contours.parallel
rm contours.parallel

# rm -f contours.pbf
# ./osmconvert64 *.o5m -o=contours.pbf

#osmium merge *.hgt.tif.pbf -o contours.pbf
#osmium merge N??E008.hgt.tif.pbf -o E008.pbf

#osmosis --rx N51E008.hgt.tif.pbf --rx N52E008.hgt.tif.pbf --merge --wx contours.pbf

#osm2pgsql --slim -d contours -C 12000 --number-processes 10 --style /usr/src/OpenTopoMap/mapnik/osm2pgsql/contours.style contours.pbf

#Winterberg:
#osm2pgsql --slim -d contours -C 12000 --number-processes 10 --style /usr/src/OpenTopoMap/mapnik/osm2pgsql/contours.style N51E008.hgt.tif.pbf

#gdal_contour --config GDAL_CACHEMAX 64 -f PostgreSQL -i 10 /external-data/srtm_data/warp-90.tif "PG:dbname=contours"
#gdal_contour --config GDAL_CACHEMAX 2048 -i 10 /external-data/srtm_data/warp-90.tif contours.pbf

touch /external-data/contours-import-complete

# E006E008
# 2021-10-25 17:47:17    Processed 8055129 nodes in 38s - 212k/s
# 2021-10-25 17:47:17    Processed 115064 ways in 12s - 10k/s
# 2021-10-25 17:47:17    Processed 0 relations in 0s - 0/s