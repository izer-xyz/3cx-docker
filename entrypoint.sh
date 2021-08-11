#!/usr/bin/env sh

# first time will run the wizard on port 5015
echo 1 | /usr/sbin/3CXWizard

/lib/systemd/systemd --log-target=console --log-level=err
