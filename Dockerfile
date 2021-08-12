FROM debian:buster

ARG PACKAGE_VERSION=16.0.8.9
ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

COPY systemctl /bin/
COPY 3cx-webconfig.service /etc/systemd/system/

RUN chmod +x /bin/systemctl \
    && apt-get update -qq \
    && apt-get install -qq --no-install-recommends -y unattended-upgrades wget gnupg1 \
    && wget -O- http://downloads.3cx.com/downloads/3cxpbx/public.key | apt-key add - \   
    && echo "deb http://downloads.3cx.com/downloads/debian buster main" | tee /etc/apt/sources.list.d/3cxpbx.list \
    && apt-get update -qq \
    && apt-get install -d -qq -y --no-install-recommends 3cxpbx=$PACKAGE_VERSION systemd systemd-sysv \
    && apt-get install -qq -y --no-install-recommends 3cxpbx=$PACKAGE_VERSION \
    && apt-get install -qq -y --no-install-recommends systemd systemd-sysv  \
    && apt-get clean -qq \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp* \
    && /usr/sbin/3CXCleanup \
    && systemctl enable 3cx-webconfig

VOLUME [ "/sys/fs/cgroup" ]

EXPOSE 5015/tcp 5001/tcp 5090/tcp 5090/udp

CMD    [ "/lib/systemd/systemd", "--log-target=console", "--log-level=err"]
