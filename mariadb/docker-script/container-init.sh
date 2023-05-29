#!/bin/bash

container_name=$1
image_version=$2
root_password=$3
data_path=$4

if [ -z $data_path ]
then
  echo "Some parameter value is empty. Usage: container-init.sh <container_name> <image_version> <root_password> <data_path>"
  exit 1
fi

echo "Create MariaDB container."
(docker run --privileged --cgroupns=host --name $container_name -d -p 3306:3306 -v $data_path:/var/lib/mysql -v /sys/fs/cgroup:/sys/fs/cgroup:rw -e MARIADB_ROOT_PASSWORD=$root_password hjben/mariadb:$image_version)
code=$?

if [ $code -gt 0 ]
then
  echo "Error raised while creating container. If container exists, remove the container using container-remove.sh file."
  exit 1
fi

echo "Done."

docker exec -it $container_name bash -c "/sh/init.sh"