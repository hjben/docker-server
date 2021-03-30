#!/bin/bash

root_password=$1

if [ -z "$root_password" ]
then
  echo "No root password found to set"
  exit 1
else
  cat << EOF > /remote.sql
set password for 'root'@'localhost' = password('$root_password');
flush privileges;
grant all privileges on *.* to 'root'@'%' identified by '$root_password';
EOF

mysql -u root < /remote.sql
fi

rm -f /remote.sql

echo "MariaDB root password set"
export MARIADB_ROOT_PASSWORD=$root_password