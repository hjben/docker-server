#!/bin/bash

flag=$1

if [ -z $flag ]
then
  flag="none"
fi

if [ $flag = "clean" ]
then
  echo "Clean CMAK service logs."
  docker exec -it cmak bash -c "rm -f /usr/local/cmak/RUNNING_PID"
  echo "Done."
fi

echo "Start CMAK service."
docker exec -it cmak /bin/bash -c "cmak -Dconfig.file=/usr/local/cmak/conf/application.conf -Dhttp.port=9000"