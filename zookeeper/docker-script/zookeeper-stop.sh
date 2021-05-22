#!/bin/bash

servers=$1

if [ -z $servers ]
then
  echo "Some parameter value is empty. Usage: zookeeper-stop.sh <(The # of ensemble)servers [odd number]>"
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

echo "Stop Zookeeper service."
for server in $(seq 1 $servers)
  do
    docker exec zoo$server /bin/bash -c "zkServer.sh stop"
  done
echo "Done."