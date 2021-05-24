#!/bin/bash

workers=$1
core=$2
mem=$3

if [ -z $mem ]
then
  echo "Some parameter value is empty. Usage: spark-start.sh <(The # of) workers [integer]> <(CPU)core [integer]> <mem (GiB) [integer]>"
  exit 1
fi

if [[ ! $workers =~ ^-?[0-9]+$ ]]
then
  echo "The # of workers is not integer."
  exit 1
fi

if [[ ! $core =~ ^-?[0-9]+$ ]]
then
  echo "CPU core for spark worker is not integer."
  exit 1
fi

if [[ ! $mem =~ ^-?[0-9]+$ ]]
then
  echo "Memory size for spark worker is not integer."
  exit 1
fi

echo "Start Spark service."
docker exec master bash -c "start-master.sh"
sleep 1

docker exec master bash -c "start-worker.sh spark://master:7077 -c $core -m $(echo $mem)G"

for worker in $(seq 1 $workers)
do
  docker exec worker$worker bash -c "start-worker.sh spark://master:7077 -c $core -m $(echo $mem)G"
done
echo "Done."