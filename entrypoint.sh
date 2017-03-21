#!/bin/bash

. /etc/.env

if [ -z "$CLUSTER_NAME" ]; then
        echo >&2 'Error:  You need to specify CLUSTER_NAME'
        exit 1
fi

if [ -z "$DISCOVERY_SERVICE" ]; then
        echo >&2 'Error:  You need to specify DISCOVERY_SERVICE'
        exit 1
fi

sed -e "s;%ADMIN_USER%;${ADMIN_USER};g" \
-e "s;%ADMIN_PASS%;${ADMIN_PASS};g" \
-e "s;%ADMIN_PORT%;${ADMIN_PORT};g" \
/etc/proxysql.tmpl > /etc/proxysql.cnf

/usr/bin/proxysql --initial -f -c /etc/proxysql.cnf &

sleep 10 # allow proxysql to start gracefully
echo 'Adding nodes'
exec /usr/bin/dbwatch
