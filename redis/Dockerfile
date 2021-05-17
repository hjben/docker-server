FROM hjben/centos-systemd:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

RUN dnf install -y redis
ADD sh/init.sh /sh/

EXPOSE 6379
