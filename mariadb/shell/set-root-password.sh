#!/bin/bash

root_password=$1

if [ -z "$root_password" ]
then
  echo "No root password found to set."
  exit 1
else
  cat << EOF > /shell/remote.sql
set password for 'root'@'localhost' = password('$root_password');
flush privileges;
EOF

  echo "Setting new root password..."
  if [ $MARIADB_ROOT_PASSWORD != $root_password ]
  then
    mysql -u root -p $MARIADB_ROOT_PASSWORD < /shell/remote.sql
  else
    echo "grant all privileges on *.* to 'root'@'%' identified by '$root_password';" >> /shell/remote.sql
    (mysql -u root < /shell/remote.sql 2> /dev/null)
    code=$?
    if [ code != "0" ]
    then
      echo "Password is already set."
    else
      echo "Done."
    fi
  fi
fi

rm -f /shell/remote.sql

export MARIADB_ROOT_PASSWORD=$root_password
