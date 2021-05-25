#!/bin/bash

spark_version=$1
workers=$2
core=$3
mem=$4
jupyter_workspace_path=$5
log_path=$6

if [ -z $log_path ]
then
  echo "Some parameter value is empty. Usage: compose-up.sh <spark_version> <(The # of) workers [integer]> <(CPU)core [integer]> <mem (GiB) [integer]> <jupyter_workspace_path> <log_path>"
  exit 1
fi

if [[ ! $workers =~ ^-?[0-9]+$ ]]
then
  echo "The # of workers is not integer."
  exit 1
elif [[ $workers -le 1 ]]
then
  workers=1
elif [[ $workers -gt 5 ]]
then
  workers=5
fi

if [[ ! $core =~ ^-?[0-9]+$ ]]
then
  echo "CPU core for spark worker is not integer."
  exit 1
elif [[ $core -lt 1 ]]
then
  core=1
fi

if [[ ! $mem =~ ^-?[0-9]+$ ]]
then
  echo "Memory size for spark worker is not integer."
  exit 1
elif [[ $mem -lt 1 ]]
then
  mem=1
fi

echo "Set docker-compose.yml file."

for worker in $(seq 1 $workers)
do
  worker_list+=worker$worker
  if [[ ! $worker -eq $workers ]]
  then
    worker_list+='
'
  fi
done

cat << EOF > slaves
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# A Spark Worker will be started on each of the machines listed below.
master
$worker_list
EOF

for worker in $(seq 1 $workers)
do
  ip_addr+='      - "'worker$worker':10.0.2.'$(($worker + 3))'"
'
done

for worker in $(seq 1 $workers)
do
  spark_service+='  'worker$worker':
    image: hjben/spark:'$spark_version'-jdk1.8.0
    hostname: 'worker$worker'
    container_name: 'worker$worker'
    privileged: true
    ports:
      - '$((8081+($worker)))':8081
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
      - '$jupyter_workspace_path':/root/workspace
      - '$log_path'/worker'$worker':/usr/local/spark/logs
    networks:
      spark-cluster:
        ipv4_address: 10.0.2.'$(($worker+3))'
    extra_hosts:
      - "jupyter-lab:10.0.2.2"
      - "cmak:10.0.2.3"
'$ip_addr
  if [[ ! $worker -eq $workers ]]
  then
    spark_service+='
'
  fi
done

cat << EOF > docker-compose.yml
services:
  jupyter-lab:
    image: hjben/jupyter-lab:spark-livy
    hostname: jupyter-lab
    container_name: jupyter-lab
    privileged: true
    ports:
      - 8888:8888
      - 4040-4044:4040-4044
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
      - $jupyter_workspace_path:/root/workspace
    networks:
      spark-cluster:
        ipv4_address: 10.0.2.2
    extra_hosts:
      - "jupyter-lab:10.0.2.2"
      - "master:10.0.2.3"
$ip_addr
  master:
    image: hjben/spark:$spark_version-livy
    hostname: master
    container_name: master
    privileged: true
    ports:
      - 8080-8081:8080-8081
      - 8998:8998
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
      - $jupyter_workspace_path:/root/workspace
      - $log_path/master:/usr/local/spark/logs
    networks:
      spark-cluster:
        ipv4_address: 10.0.2.3
    extra_hosts:
      - "jupyter-lab:10.0.2.2"
      - "master:10.0.2.3"
$ip_addr
$spark_service
networks:
 spark-cluster:
  ipam:
   driver: default
   config:
   - subnet: 10.0.2.0/24
EOF
echo "Done."

echo "Docker-compose container run."
echo "Remove old containers."
docker-compose down --remove-orphans
sleep 1

echo "Create new containers."
docker-compose up -d
sleep 1

docker cp ./slaves master:/usr/local/spark/conf/slaves
for worker in $(seq 1 $workers)
do
  docker cp ./slaves worker$worker:/usr/local/spark/conf/slaves
done
echo "Done."

rm -f slaves

./spark-start.sh $workers $core $mem
./jupyter-start.sh