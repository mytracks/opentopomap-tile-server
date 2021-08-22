FROM ubuntu:16.04

RUN apt-get update && apt-get install -y libboost-all-dev git-core tar unzip wget bzip2 build-essential autoconf libtool libxml2-dev libgeos-dev libgeos++-dev libpq-dev libbz2-dev libproj-dev munin-node munin libprotobuf-c0-dev protobuf-c-compiler libfreetype6-dev libpng12-dev libtiff5-dev libicu-dev libgdal-dev libcairo-dev libcairomm-1.0-dev apache2 apache2-dev libagg-dev liblua5.2-dev ttf-unifont lua5.1 liblua5.1-dev libgeotiff-epsg cmake lua5.3 liblua5.3-dev devscripts libjson-perl libipc-sharelite-perl libgd-perl debhelper gdal-bin python-gdal postgresql postgresql-contrib postgis postgresql-9.5-postgis-2.2 libmapnik3.0 libmapnik-dev mapnik-utils python-mapnik unifont supervisor sudo python3-setuptools python3-matplotlib python3-bs4 python3-numpy python3-gdal && apt-get clean

RUN useradd -u 1000 -s /bin/bash -d /home/gis -m -G root gis

RUN mkdir /var/lib/otm && chown gis.root /var/lib/otm

COPY postgresql.conf /etc/postgresql/9.5/main/postgresql.conf

WORKDIR /usr/src
RUN git clone git://github.com/openstreetmap/osm2pgsql.git \
  && cd osm2pgsql \
  && mkdir build && cd build \
  && cmake .. \
  && make \
  && make install
RUN git clone -b switch2osm git://github.com/SomeoneElseOSM/mod_tile.git \
  && cd mod_tile \
  && ./autogen.sh \
  && ./configure \
  && make \
  && make install \
  && make install-mod_tile \
  && ldconfig
COPY renderd.conf /usr/local/etc/renderd.conf
RUN mkdir /var/lib/mod_tile && mkdir /var/run/renderd
COPY mod_tile.conf /etc/apache2/conf-available/mod_tile.conf
RUN a2enconf mod_tile
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

COPY supervisord.conf /etc/supervisor/conf.d/

#COPY setup.sh /etc/setup.sh

#RUN /etc/setup.sh

RUN git clone https://github.com/der-stefan/OpenTopoMap.git

RUN wget http://katze.tfiu.de/projects/phyghtmap/phyghtmap_2.10.orig.tar.gz \
 && tar -xvzf phyghtmap_2.10.orig.tar.gz \
 && cd phyghtmap-2.10 \
 && python3 setup.py install


#RUN mkdir /home/gis/srtm && cd /home/gis/srtm
#COPY srtm.txt /home/gis/srtm/srtm.txt
#COPY srtm.sh /home/gis/srtm/srtm.sh
#RUN cd /home/gis/srtm \
# && ./srtm.sh

RUN cd /usr/src/OpenTopoMap/mapnik/tools/ \
 && cc -o saddledirection saddledirection.c -lm -lgdal \
 && cc -Wall -o isolation isolation.c -lgdal -lm -O2

COPY otm /otm

#CMD ["/usr/bin/supervisord", "-n"]
CMD ["/otm/start.sh"]

