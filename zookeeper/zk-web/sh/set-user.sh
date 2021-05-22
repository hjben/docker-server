#!/bin/bash

user=$1
pass=$2

if [ -n "$user" ] && [ -n "$pass" ]
then
    USER="$user"
    PASS="$pass"
fi

sed -i "s/:users.*/:users {\"${USER}\" \"${PASS}\"}/g" /zk-web/conf/zk-web-conf.clj
echo "User Information Configured to ${USER}/${PASS}"
