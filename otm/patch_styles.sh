#!/bin/sh

cd /usr/src/OpenTopoMap/mapnik/styles-otm
for xmlfile in *.xml
do
    sed -i -e 's#minscale_zoom17;#minscale_zoom20;#g' -e 's#<TextSymbolizer #<TextSymbolizer avoid-edges="true" #g' -e 's#<ShieldSymbolizer #<ShieldSymbolizer avoid-edges="true" #g' "$xmlfile"
    #sed -i -e 's#<TextSymbolizer #<TextSymbolizer avoid-edges="true" #g' -e 's#<ShieldSymbolizer #<ShieldSymbolizer avoid-edges="true" #g' "$xmlfile"
done
