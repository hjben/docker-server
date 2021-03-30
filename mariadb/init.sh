#!/bin/bash

systemctl enable mariadb
systemctl start mariadb

root_password=$MARIADB_ROOT_PASSWORD

source set-root-password.sh $root_password
