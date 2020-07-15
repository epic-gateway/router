#!/usr/bin/env sh
set -e


DEFAULT_INT=`ip -4 route show default | awk '{print $5}'`
if [ -z "DEFAULT_INT" ]; then
    ROUTER_ID='127.0.0.1'
else
    ROUTER_ID=`ip -4 -br addr show "$DEFAULT_INT" | awk '{split($3,a,"/"); print a[1] }'`
fi

sed -i "s/ROUTERID/${ROUTER_ID}/g" /usr/local/include/routerid.conf

exec "$@"