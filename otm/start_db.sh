#!/bin/bash

if [ ! -f /db/PG_VERSION ]; then
    sudo -u postgres /usr/lib/postgresql/12/bin/pg_ctl -D /db/ initdb -o "--locale C.UTF-8" || exit -1
    sudo -u postgres cp /etc/postgresql/12/main/postgresql.conf /db || exit -1
fi

/etc/init.d/postgresql start

sleep 5
