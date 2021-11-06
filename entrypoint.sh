#!/usr/bin/env sh


# TODO: 1) check if first time run 2) check if backup exists -> restore 3) no backup -> run wizard

. /usr/share/3cxpbx/3cxpbx.conf

# first run?
if [ ! -d $var ]; then
   echo Configure instance ...
   
   # has setup config
   if [ -f /etc/3cxpbx/setupconfig.xml ]; then
     echo Using existing /etc/3cxpbx/setupconfig.xml   
   else   
     # has backup?
     if [ -f $3CX_BACKUP_FILE ]; then
       echo Restore from $3CX_BACKUP_FILE ...
       echo Generate default restore config /etc/3cxpbx/setupconfig.xml ...
     else
       echo Run WebConfig on port :5015
     fi   
   fi  
   
   # run wizard
   echo 1 | /usr/sbin/3CXWizard
fi

exec /lib/systemd/systemd --log-target=console --log-level=err
