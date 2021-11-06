#!/usr/bin/env sh


# TODO: 1) check if first time run 2) check if backup exists -> restore 3) no backup -> run wizard
# first time will run the wizard on port 5015
echo 1 | /usr/sbin/3CXWizard

exec /lib/systemd/systemd --log-target=console --log-level=err
