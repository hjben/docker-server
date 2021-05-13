#!/bin/bash

container_name=$1
forward_port=$2
data_path=$3
root_password=$4
image_name=$5

if [ -z $image_name ]
then
  echo "Some parameter value is empty. Usage: container-init.sh [container_name] [forward_port] [data_path] [root_password] [image_name]"
  exit 1
fi

if [[ ! $forward_port =~ ^[0-9]+$ ]]
then
  echo "Invalid port. forward_port must be a numeric value"
  exit 1
fi

echo "Create MariaDB container."
(docker run --privileged --name $container_name -d -p $forward_port:3306 -v $data_path:/var/lib/mysql -v /sys/fs/cgroup:/sys/fs/cgroup -e MARIADB_ROOT_PASSWORD=$root_password $image_name)
code=$?

if [ $code -gt 0 ]
then
  echo "Error raised while creating container. If container exists, remove the container using container-remove.sh file."
  exit 1
fi

echo "Done."

docker exec -it $container_name bash -c "/sh/init.sh"