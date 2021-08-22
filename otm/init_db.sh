#!/bin/bash

sudo -u postgres createuser --createdb gis -s
sudo -u gis createdb gis
sudo -u gis psql -d gis -c 'CREATE EXTENSION postgis;'
