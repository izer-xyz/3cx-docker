#!/usr/bin/env sh

. /usr/share/3cxpbx/3cxpbx.conf

# first run?
if [ ! -d $var ]; then
   echo Configure instance ...
   
   # has setup config
   if [ -f /etc/3cxpbx/setupconfig.xml ]; then
     echo Using existing /etc/3cxpbx/setupconfig.xml   
   else   
     # has backup?
     if [ -f $CX_BACKUP_FILE ]; then
       echo Restore from $CX_BACKUP_FILE ...
       echo Generate default restore config /etc/3cxpbx/setupconfig.xml ...
       mkdir /etc/3cxpbx
       envsubst < /usr/local/share/3cx-restore-setupconfig.xml > /etc/3cxpbx/setupconfig.xml
     else
       echo Run WebConfig on port :5015
     fi   
   fi  
   
   # run wizard after systemd
   systemctl enable 3cx-webconfig
else
   echo Config exists $var
   systemctl disable 3cx-webconfig
fi

exec /lib/systemd/systemd --log-target=console --log-level=err
