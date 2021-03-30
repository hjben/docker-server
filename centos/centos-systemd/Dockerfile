FROM centos:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV container docker
ENV TZ=Asia/Seoul

RUN dnf -y update; dnf clean all
RUN dnf -y install systemd; dnf clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN dnf install -y openssh-server openssh-clients openssh-askpass
RUN dnf install -y vim
RUN dnf install -y net-tools
RUN dnf install -y wget

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/sbin/init"]
