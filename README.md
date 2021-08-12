# 3cx-docker


```
docker run \
  -d  \
  --tmpfs /tmp \
  --tmpfs /run \
  --tmpfs /run/lock \
  -v      /sys/fs/cgroup:/sys/fs/cgroup:ro \
          ghcr.io/izer-xyz/3cx:latest
```


# References

 * https://www.3cx.com/docs/ports/
 * https://github.com/ekondayan/docker-3cx
 * https://hub.docker.com/r/jrei/systemd-debian
