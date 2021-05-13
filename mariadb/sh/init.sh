#!/bin/bash

echo "Initialize MariaDB."
systemctl enable mariadb
/sh/start.sh

root_password=$MARIADB_ROOT_PASSWORD
/sh/set-root-password.sh $root_password init
echo "Initialization done."