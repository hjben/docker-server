#!/bin/bash

container_name=$1
new_password=$2

if [ -z $new_password ]
then
  echo "Some parameter value is empty. Usage: change-root-password.sh <container_name> <new_password>"
  exit 1
fi

docker exec -it $container_name bash -c "source /sh/set-root-password.sh $new_password"
