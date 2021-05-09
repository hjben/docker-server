FROM hjben/centos-systemd:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

RUN dnf install -y redis
ADD redis-init.sh /

EXPOSE 6379

ENTRYPOINT ["/usr/sbin/init"]