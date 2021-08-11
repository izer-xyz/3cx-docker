FROM debian:buster

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

COPY systemctl /sbin/

RUN chmod +x /sbin/systemctl \
    && apt update \
    && apt install --no-install-recommends -y wget gnupg1 \
    && wget -O- http://downloads.3cx.com/downloads/3cxpbx/public.key | apt-key add - \   
    && echo "deb http://downloads.3cx.com/downloads/debian buster main" | tee /etc/apt/sources.list.d/3cxpbx.list \
    && apt update \
    && apt -y --no-install-recommends install 3cxpbx \
    && rm -rf /var/lib/3cxpbx \
    && apt install --no-install-recommends -y systemd systemd-sysv  \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

COPY   setupconfig.xml /etc/3cxpbx/setupconfig.xml
COPY   entrypoint.sh /

VOLUME [ "/sys/fs/cgroup" ]

CMD    [ "/entrypoint.sh" ]
