#!/bin/bash

workers=$1

if [ -z $workers ]
then
  echo "Some parameter value is empty. Usage: spark-stop.sh <(The # of) workers [integer]>"
  exit 1
fi

if [[ ! $workers =~ ^-?[0-9]+$ ]]
then
  echo "The # of workers is not integer."
  exit 1
fi

echo "Stop Spark service."
for worker in $(seq 1 $workers)
do
  docker exec -it worker$worker bash -c "stop-worker.sh"
done

docker exec -it master bash -c "stop-worker.sh"
docker exec -it master bash -c "stop-master.sh"
echo "Done."