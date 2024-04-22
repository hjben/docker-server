#!/bin/bash

echo "Initialize MariaDB."
/usr/bin/mysql_install_db --user=mysql

systemctl enable mariadb
/sh/start.sh

root_password=$MARIADB_ROOT_PASSWORD
/sh/set-root-password.sh $root_password init

cat << EOF > /sh/grant.sql
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$maria_root_password';
EOF

mysql -u root -p < /sh/grant.sql
      
echo "Initialization done."