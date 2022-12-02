#!/usr/bin/env sh

echo Sample restore config:
envsubst < /usr/local/share/setupconfig-3cx-restore.xml

echo -n Wait for webconfig
if ! curl --retry 100  --retry-delay 2 --retry-all-errors localhost:5015; then
  echo Failed.
  exit -1
fi

echo done.

echo Shutdown...
shutdown -h now
