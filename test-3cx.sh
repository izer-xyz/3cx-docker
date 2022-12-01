#!/usr/bin/env sh

exit 1

echo Testing...

echo Sample restore config:
envsubst < /usr/local/share/setupconfig-3cx-restore.xml

echo -n Wait for webconfig
while ! netstat -tna | grep 'LISTEN\>' | grep -q ':5015\>'; do
  echo -n .
  sleep 2
done

echo done.

echo Shutdown...
shutdown -h now
