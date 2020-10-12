#!/usr/bin/env sh
#!/bin/bash
set -e

if  [ ! -f  "/usr/local/include/bird/envvar.conf" ]
then 
    cp -r /tmp/configlets/* /usr/local/include/bird
fi

sed -i "s/K8SIPADDR/${BIRD_HOST}/g" /usr/local/include/bird/envvar.conf

exec "$@"