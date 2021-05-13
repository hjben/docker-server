#!/bin/bash

root_password=$1
flag=$2

if [ -z $flag ]
then
  flag="change"
fi

if [ -z "$root_password" ]
then
  echo "No root password found to set."
  exit 1
else
  cat << EOF > /sh/remote.sql
set password for 'root'@'localhost' = password('$root_password');
set password for 'root'@'%' = password('$root_password');
flush privileges;
EOF

  echo "Setting root password..."
  if [ $flag = "init" ]
  then
    echo "grant all privileges on *.* to 'root'@'%' identified by '$root_password';" >> /sh/remote.sql
    (mysql -u root < /sh/remote.sql 2> /dev/null)
    code=$?

    rm -f /sh/remote.sql
    if [ $code -gt 0 ]
    then
      echo "Password is already set."
    fi
    
  else
    echo "Enter the original password."
    (mysql -u root -p < /sh/remote.sql)
    code=$?

    rm -f /sh/remote.sql
    if [ $code -gt 0 ]
    then
      exit 1
    fi
  fi
fi

echo "Done."
