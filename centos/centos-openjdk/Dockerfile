FROM hjben/centos-systemd:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV JAVA_VERSION 11
ENV JAVA_HOME /usr/lib/jvm/java-$JAVA_VERSION-openjdk
ENV PATH $PATH:$JAVA_HOME/bin

RUN sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
RUN sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

RUN dnf install -y java-$JAVA_VERSION-openjdk-devel