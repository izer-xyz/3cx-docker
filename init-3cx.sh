#!/usr/bin/env sh

. /usr/share/3cxpbx/3cxpbx.conf

# first run?
if [ ! -d $var ]; then
   echo First run. Configure instance ...
   echo Check config tool logs in case of any issues /var/lib/3cxpbx/Data/Logs/PbxConfigTool.log
   
   # has setup config
   if [ -f /etc/3cxpbx/setupconfig.xml ]; then
     echo Using existing /etc/3cxpbx/setupconfig.xml   
   else   
     # has backup?
     if [ -f ${CX_BACKUP_FILE:-/no-default-backup} ]; then
       echo Backup found. No WebConfig. 
       echo Restore from $CX_BACKUP_FILE ...
       echo Generate default restore config /etc/3cxpbx/setupconfig.xml ...
       mkdir /etc/3cxpbx
       envsubst < /usr/local/share/setupconfig-3cx-restore.xml > /etc/3cxpbx/setupconfig.xml
     else
       echo Run WebConfig on port :5015
     fi   
   fi  
   
   # run wizard after systemd
   systemctl enable setup-3cx
else
   echo Config exists $var
   systemctl disable setup-3cx
fi

if [ "${MODE}" = "test" ]; then
   echo Test mode.
   setsid /usr/sbin/3CXWizard &
   sleep 3
   netstat -ln | grep 5015
   exit 0
else
   exec /lib/systemd/systemd --log-target=console --log-level=err
fi
