#!/bin/bash

echo "Initialize MariaDB."
systemctl enable mariadb
/shell/start.sh

root_password=$MARIADB_ROOT_PASSWORD
source /shell/set-root-password.sh $root_password
echo "Initialization done."