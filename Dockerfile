FROM debian:buster-slim

ARG PACKAGE_VERSION=18.0.2.314
ARG DEBIAN_VERSION=buster

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

COPY systemctl /bin/

RUN chmod +x /bin/systemctl \
    && apt-get update -qq \
    && apt-get install -qq --no-install-recommends -y unattended-upgrades ca-certificates wget gnupg1 gettext-base \
    && wget -O- http://downloads.3cx.com/downloads/3cxpbx/public.key | apt-key add - \   
    && echo "deb http://repo.3cx.com/3cx $DEBIAN_VERSION main" | tee /etc/apt/sources.list.d/3cxpbx.list 
RUN apt-get update -qq \
    && apt-get upgrade -qq \
    && apt-get install -qq -y --no-install-recommends 3cxpbx=$PACKAGE_VERSION \
    && apt-get update -qq \
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
    && echo ForwardToConsole=yes >> /etc/systemd/journald.conf \
    && echo MaxLevelConsole=err >> /etc/systemd/journald.conf \
    && /usr/sbin/3CXCleanup \
    && systemctl enable nginx

VOLUME [ "/sys/fs/cgroup" ]

EXPOSE 5015/tcp 5000/tcp 5001/tcp 5090/tcp 5090/udp

COPY setup-3cx.service /etc/systemd/system/
COPY init-3cx.sh /usr/local/bin/
COPY setupconfig-3cx-restore.xml /usr/local/share/

COPY test-3cx.sh /usr/local/bin/

CMD    [ "init-3cx.sh" ]
