#!/bin/bash

flag=$1

if [ -z $flag ]
then
  flag="none"
fi

if [ $flag = "all" ]
then
  echo "Stop Hive MetaDB."
  docker exec -it mariadb bash -c "/sh/stop.sh"
fi

echo "Stop Hive server."
docker exec -it master bash -c "stop-server.sh"
echo "Done."