FROM hjben/centos-openjdk:11
MAINTAINER hjben <hj.ben.kim@gmail.com>

RUN dnf install -y git

WORKDIR /usr/bin
RUN wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
RUN chmod 755 lein

WORKDIR /
RUN git clone git://github.com/qiuxiafei/zk-web.git

WORKDIR /zk-web
RUN lein deps

WORKDIR /
ADD set-user.sh /
RUN chmod 755 set-user.sh

EXPOSE 8080

ENTRYPOINT ["/usr/sbin/init"]


