#!/bin/bash

flag=$1

if [ -z $flag ]
then
  flag="none"
fi

echo "Start Hbase service."
if [ $flag = "clean" ]
then
  echo "Clean Hbase."
  docker exec -it master bash -c "hbase clean --cleanAll"
  echo "Done."
fi

docker exec -it master bash -c "start-hbase.sh"
docker exec -it master bash -c "hbase-daemon.sh --config /usr/local/hbase/conf foreground_start master"