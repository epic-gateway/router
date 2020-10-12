#/bin/bash
# Monitors the config map and reloads bird on change

inotifywait -m -e modify /usr/local/include/bird/*.conf |
while read events ; do
  /usr/local/sbin/birdc configure
done