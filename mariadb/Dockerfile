FROM hjben/centos-systemd:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

RUN curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash
RUN dnf install -y MariaDB-server

RUN mkdir /shell
ADD shell/*sh /shell
ADD conf/*cnf /etc/my.cnf.d/

RUN chmod 755 /shell/*sh

EXPOSE 3306
