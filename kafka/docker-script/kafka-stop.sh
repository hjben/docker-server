#!/bin/bash

servers=$1

if [ -z $servers ]
then
  echo "Some parameter value is empty. Usage: kafka-stop.sh <servers [integer]>"
  exit 1
fi

if [[ ! $servers =~ ^-?[0-9]+$ ]]
then
  echo "The # of servers is not integer."
  exit 1
fi

echo "Stop Kafka service."
for server in $(seq 1 $servers)
do
  docker exec -it kafka$server kafka-server-stop.sh
done
echo "Done."