FROM hjben/centos-systemd:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV JAVA_VERSION 11
ENV JAVA_HOME /usr/lib/jvm/java-$JAVA_VERSION-openjdk
ENV PATH $PATH:$JAVA_HOME/bin

RUN dnf install -y java-$JAVA_VERSION-openjdk-devel

ENTRYPOINT ["/usr/sbin/init"]