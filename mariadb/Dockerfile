FROM hjben/centos-systemd:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

RUN curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash
RUN dnf install -y MariaDB-server

ADD init.sh /
ADD set-root-password.sh /
ADD *cnf /etc/my.cnf.d/

RUN chmod 755 init.sh
RUN chmod 755 set-root-password.sh

EXPOSE 3306
