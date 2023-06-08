#!/bin/bash

container_name=$1

if [ -z $container_name ]
then
  echo "container_name is empty. Usage: container-remove.sh <container_name>"
  exit 1
fi

docker rm -f $container_name