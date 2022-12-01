#!/usr/bin/env sh

echo Testing...

echo Sample restore config:
envsubst < /usr/local/share/setupconfig-3cx-restore.xml

netstat -tna | grep 'LISTEN\>' | grep -q ':5015\>

echo -n Wait for webconfig
while ! netstat -tna | grep 'LISTEN\>' | grep -q ':5015\>'; do
  echo -n .
  sleep 2
done

echo done.

echo Shutdown...
shutdown -h now
