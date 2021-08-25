#!/bin/bash

if [ ! -f /var/lib/postgresql/9.5/main/PG_VERSION ]; then
    sudo -u postgres /usr/lib/postgresql/9.5/bin/pg_ctl -D /var/lib/postgresql/9.5/main/ initdb -o "--locale C.UTF-8"
fi

/etc/init.d/postgresql start
