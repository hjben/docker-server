#!/bin/bash

servers=$1
flag=$2

if [ -z $flag ]
then
  echo "Some parameter value is empty. Usage: zookeeper-start.sh <(The # of ensemble) servers [odd number]> <flag [ start | restart ]>"
  exit 1
fi

if [[ ! $servers =~ ^-?[0-9]+$ ]]
then
  echo "The # of ensemble servers is not integer."
  exit 1
elif [[ $servers -le 1 ]]
then
  servers=1
elif [[ $servers -gt 5 ]]
then
  servers=5
fi

if [[ $servers -eq 2 ]] || [[ $servers -eq 4 ]]
then
  echo "THe # of ensemble servers must be odd number"
  exit 1
fi

if [ $flag != "start" ] && [ $flag != "restart" ] ; then
  echo "Wrong flag detected. Available flag is [ start | restart ]"
  exit 1
fi

echo "Start Zookeeper service."
if [ $flag = "restart" ]
then
  for server in $(seq 1 $servers)
  do
    docker exec zoo$server bash -c "zkServer.sh restart"
  done
elif [ $flag = "start" ]
then
  for server in $(seq 1 $servers)
  do
    docker exec zoo$server bash -c "zkServer.sh start"
  done
fi
echo "Done."
