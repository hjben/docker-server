#!/bin/bash

container_name=$1
image_version=$2

if [ -z $image_version ]
then
  echo "Some parameter value is empty. Usage: container-init.sh <container_name> <image_version>"
  exit 1
fi

echo "Create Jupyter-lab container."
(docker run --privileged --name $container_name -d -p 8888:8888 -v /sys/fs/cgroup:/sys/fs/cgroup hjben/jupyter-lab:$image_version)
code=$?

if [ $code -gt 0 ]
then
  echo "Error raised while creating container. If container exists, remove the container using container-remove.sh file."
  exit 1
fi

echo "Done."
sleep 2

docker exec -it $container_name bash -c "jupyter lab"