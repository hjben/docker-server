#!/bin/bash

server=$1

if [ -z $server ]
then
  echo "Some parameter value is empty. Usage: kafka-start.sh <server [integer]>"
  exit 1
fi

if [[ ! $server =~ ^-?[0-9]+$ ]]
then
  echo "The # of server is not integer."
  exit 1
fi

echo "Start Kafka service $server."
docker exec -it kafka$server /sh/start-kafka.sh