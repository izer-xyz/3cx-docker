[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/izer-xyz/3cx-docker/push?style=flat-square)](https://github.com/izer-xyz/3cx-docker/actions/workflows/push.yml)
[![GitHub Release](https://img.shields.io/github/v/release/izer-xyz/3cx-docker?style=flat-square)](https://github.com/izer-xyz/3cx-docker/releases)
[![DockerHub Pulls](https://img.shields.io/docker/pulls/izerxyz/3cx?style=flat-square)](https://hub.docker.com/r/izerxyz/3cx)

> Use at your own risk. It comes with no guarantee. Always do backups. Etc.

# 3cx-docker

3CX PBX Phone System docker image:

 * Multi arch build (Arm + x86)
 * No special priviledges (CAP_* or --priviledged)
 * Simpler / automated build process (one step)
 * Easier setup of 3CX (runs the web config on first start)

## Usage 

 1. Start the container
```
$ docker run \
  -d  \
  -t \
  --tmpfs /tmp \
  --tmpfs /run \
  --tmpfs /run/lock \
  -v      /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -p      5015:5015 \
  -p      5000:5000 \
  -p      5001:5001 \
  -p      5060:5060 \
  -p      5060:5060/udp \
  -p      5090:5090 \
  -p      5090:5090/udp \
          ghcr.io/izer-xyz/3cx:latest
```

 2. Setup 3CX using the web config (this only runs the first time the container starts)
```
  chrome http://[hostname]:5015/?v=2
```

## Upgrade process

Upgrade (and setup process) only works on the first run. If fails wipe the container and start again or use `3CXCleanup`. 

### Automated / simple

Upgrade using simple/opinionted [restore config](setupconfig-3cx-restore.xml):

```
$ docker run \
  -d  \
  -t \
  --tmpfs /tmp \
  --tmpfs /run \
  --tmpfs /run/lock \
  -v      /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -p      5015:5015 \
  -p      5000:5000 \
  -p      5001:5001 \
  -p      5060:5060 \
  -p      5060:5060/udp \
  -p      5090:5090 \
  -p      5090:5090/udp \
  -v    /mnt/3cx:/mnt/3cx \
  --env CX_BACKUP_FILE=/mnt/voip/backups/3CXScheduledBackup.zip \
  --env CX_PUBLIC_IP=X.X.X.X \
  --env CX_INTERNAL_FQDN=3cx.example.com \
          ghcr.io/izer-xyz/3cx:latest
```
Where,
 * `CX_BACKUP_FILE`: is the scheduled backup file location to restore from
 * `CX_PIBLIC_IP`: public ipv4 address of the server
 * `CX_INTERNAL_FQDN`: internal full qualified domain name of the server (not the 3cx supplied public domain)

### Automated custom (not tested)

BYO [`setupconfig.xml`](https://www.3cx.com/docs/configure-pbx-automatically/). The example assumes that the `/mnt/3cx/config/setupconfig.xml` exists with the approriate configuation to setup the instance.

```
$ docker run \
  -d  \
  -t \
  --tmpfs /tmp \
  --tmpfs /run \
  --tmpfs /run/lock \
  -v      /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -p      5015:5015 \
  -p      5000:5000 \
  -p      5001:5001 \
  -p      5060:5060 \
  -p      5060:5060/udp \
  -p      5090:5090 \
  -p      5090:5090/udp \
  -v    /mnt/3cx:/mnt/3cx \
  -v    /mnt/3cx/config:/etc/3cxpbx \
          ghcr.io/izer-xyz/3cx:latest
```

### Manual upgrade

 1. Backup 3cx instance (good idea to run scheduled backups as the container may not persits data)
 2. Download backup zip
 3. Upgrade container to next version
 4. Use webconfig to restore from backup zip
 5. Change backup location if it was modified (backup doesn't seem to contain the config)
 6. Check E164 Processing settings (add/remove prefixes)


## Troubleshooting

 1. Container doesn't start. `systemd` can be tricky to get going as it depends on the host (and for that reason I am unlikely to be able to help see [#4](https://github.com/izer-xyz/3cx-docker/issues/4), [#9](https://github.com/izer-xyz/3cx-docker/issues/9) ). There is a [workaround](https://github.com/izer-xyz/3cx-docker/issues/17#issuecomment-1329787269) that may help in some scenarios. Good starting point is to run the minimum process with debug enabled: 
```
 $ docker run -it --rm --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro izerxyz/3cx:latest /lib/systemd/systemd --log-level=debug --log-target=console --show-status=true
```
 
 2. Setup issues, check the logs: `/var/lib/3cxpbx/Data/Logs/PbxConfigTool.log`

 3. Failed setup (Warning this will delete all user data!): 
```
  $ docker exec -it [container id]  /usr/sbin/3CXCleanup
```

 4. Post setup issues: `/var/lib/3cxpbx/Instance0/Data/Logs/*`


# References

 * https://www.3cx.com/docs/ports/
 * https://github.com/ekondayan/docker-3cx
 * https://hub.docker.com/r/jrei/systemd-debian
 * https://github.com/docker/build-push-action/blob/master/docs/advanced/push-multi-registries.md
 * https://www.3cx.com/docs/configure-pbx-automatically/
 * https://www.3cx.com/wp-content/uploads/2016/11/setupconfig.xml
