# 3cx-docker


```
docker run \
  -d  \
  -t \
  --tmpfs /tmp \
  --tmpfs /run \
  --tmpfs /run/lock \
  -v      /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -p      5015:5015 \
  -p      5000:5000 \
  -p      5001:5001 \
  -p      5090:5090 \
  -p      5090:5090/udp \
          ghcr.io/izer-xyz/3cx:latest
```


# References

 * https://www.3cx.com/docs/ports/
 * https://github.com/ekondayan/docker-3cx
 * https://hub.docker.com/r/jrei/systemd-debian
