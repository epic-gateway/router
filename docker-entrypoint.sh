#!/usr/bin/env sh
set -e


#ROUTER_ID=`ip -4 -o a | awk '/e/ { split($4, a, "/"); print a[1] }'`
#if [ -z "$ROUTER_ID" ]; then
#    ROUTER_ID='127.0.0.1'
#fi
#
#sed -i "s/BIRD_ROUTERID/${ROUTER_ID}/g" /usr/local/etc/bird.conf

exec "$@"
