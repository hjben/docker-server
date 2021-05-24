#!/bin/bash

service=$1
worker=$2

if [ -z $service ]
then
  echo "Some parameter value is empty. Usage: airflow-start.sh <service [ webserver | scheduler | flower | worker ]> [(The # of) worker [integer]]"
  exit 1
fi

echo "Start Airflow $service."

if [ $service = "worker" ]
then
  if [ -z $worker ]
  then
    echo "Some parameter value is empty. If you want to start worker, The # of worker is needed."
    exit 1
  elif [[ ! $worker =~ ^-?[0-9]+$ ]]
  then
    echo "The # of worker is not integer."
    exit 1
  fi

  docker exec -it worker$worker bash -c "airflow celery worker"

elif [ $service = "flower" ]
then
  docker exec -it flower bash -c "airflow celery flower"

elif [ $service = "webserver" ] || [ $service = "scheduler" ] ; then
  docker exec -it $service bash -c "airflow $service"

else
  echo "Wrong service detected. Available service is [ webserver | scheduler | flower | worker ]"
  exit 1
fi
