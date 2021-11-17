#!/bin/bash

northSouth=$1 # 0/1 -> 1 bit
northSouthValue=$2 # 0-90 -> 7 bit

westEast=$3 # 0/1 -> 1 bit
westEastValue=$4  # 0-180 -> 8 bit

startid=$((10000000 + ($northSouth + ($northSouthValue * 2) + ($westEast * 512) + ($westEastValue * 1024)) * 100000000))

echo $startid

filename=""
if [ $northSouth -eq '0' ]; then
    filename="N"
else
    filename="S"
fi

filename=$(printf "%s%02d" $filename $northSouthValue)

if [ $westEast -eq '0' ]; then
    filename=$(printf "%sE" $filename)
else
    filename=$(printf "%sW" $filename)
fi

filename=$(printf "%s%03d.hgt.tif" $filename $westEastValue)

echo $filename

exit -1

#startid=$(( startid + 100000000 ))


hgttiffile=$1
startid=$2

if [ ! -f $hgttiffile.pbf ]; then
    prefix=`openssl rand -hex 12`
    phyghtmap --start-node-id=$startid --start-way-id=$startid --max-nodes-per-tile=0 -s 10 -0 --output-prefix=$prefix --pbf $hgttiffile
    mv $prefix*lon*pbf $hgttiffile.pbf
fi

# if [ ! -f $hgttiffile.o5m ]; then
#     ./osmconvert64 $hgttiffile.pbf -o=$hgttiffile.o5m
# fi
