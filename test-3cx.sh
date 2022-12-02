#!/usr/bin/env sh

echo Sample restore config:
envsubst < /usr/local/share/setupconfig-3cx-restore.xml

echo Wait for webconfig
if ! wget localhost:5015; then
  echo Failed.
  exit -1
fi

echo done.

echo Shutdown...
shutdown -h now
