#!/bin/bash

container_name=$1
image_type=$2
image_version=$3

if [ -z $image_version ]
then
  echo "Some parameter value is empty. Usage: container-init.sh <container_name> <image_type [ systemd | openjdk ]> <image_version>"
  exit 1
fi

if [ $image_type != "systemd" ] && [ $image_type != "openjdk" ] ; then
  echo "Wrong image_type detected. Available type is [ systemd | openjdk ]"
  exit 1
fi

echo "Create Rockylinux container."
(docker run --privileged --cgroupns=host --name $container_name -d -v /sys/fs/cgroup:/sys/fs/cgroup:rw hjben/rockylinux-$image_type:$image_version)
code=$?

if [ $code -gt 0 ]
then
  echo "Error raised while creating container. If container exists, remove the container using container-remove.sh file."
  exit 1
fi

echo "Done."
sleep 2

./container-exec.sh $container_name