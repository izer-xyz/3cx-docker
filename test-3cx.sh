#!/usr/bin/env sh

echo Testing...

echo -n Wait for webconfig
while ! netstat -tna | grep 'LISTEN\>' | grep -q ':5015\>'; do
  echo -n .
  sleep 2
done

echo done.

echo Shutdown...
shutdown -h now
