#!/bin/bash

container_name=$1
flag=$2

if [ -z $container_name ]
then
  echo "container_name is empty. Usage: container-run.sh [container_name] [flag: start | stop]"
  exit 1
fi

if [ $flag = "start" ]
then
  docker exec -it $container_name bash -c "/sh/start.sh"
elif [ $flag = "stop" ]
then
  docker exec -it $container_name bash -c "/sh/stop.sh"
else
  echo "Wrong flag detected. Available flag is [ start | stop ]"
  exit 1
fi