[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/izer-xyz/3cx-docker/push?style=flat-square)](https://github.com/izer-xyz/3cx-docker/actions/workflows/push.yml)
[![GitHub Release](https://img.shields.io/github/v/release/izer-xyz/3cx-docker?style=flat-square)](https://github.com/izer-xyz/3cx-docker/releases)
[![DockerHub Pulls](https://img.shields.io/docker/pulls/izerxyz/3cx?style=flat-square)](https://hub.docker.com/r/izerxyz/3cx)


# 3cx-docker

3CX PBX Phone System docker image. Advantages over [farfui/3cx](https://hub.docker.com/r/farfui/3cx) are:

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

 1. Backup 3cx instance (good idea to run scheduled backups as the container may not persits data)
 2. Download backup zip
 3. Upgrade container to next version
 4. Use webconfig to restore from backup zip
 5. Change backup location if it was modified (backup doesn't seem to contain the config)
 6. Check E164 Processing settings (add/remove prefixes)


## Troubleshooting

 * Failed setup (Warning this will delete all user data!): 
```
  $ docker exec -it [container id]  /usr/sbin/3CXCleanup
```

# References

 * https://www.3cx.com/docs/ports/
 * https://github.com/ekondayan/docker-3cx
 * https://hub.docker.com/r/jrei/systemd-debian
 * https://github.com/docker/build-push-action/blob/master/docs/advanced/push-multi-registries.md
