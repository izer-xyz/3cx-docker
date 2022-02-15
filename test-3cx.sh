#!/usr/bin/env sh

echo Testing...

echo sleep t
skeep 5

netstat -ln | grep 5015
ps x

echo Shutdown...
shutdown -h now
