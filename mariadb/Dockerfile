FROM hjben/centos-systemd:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

RUN curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash
RUN dnf install -y MariaDB-server

RUN mkdir /sh
ADD sh/*sh /sh/
ADD conf/*cnf /etc/my.cnf.d/

RUN chmod 755 /sh/*sh

EXPOSE 3306
