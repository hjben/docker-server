#!/bin/bash

hadoop_version=$1
hdfs_path=$2
log_path=$3
slaves=$4

if [ -z $slaves ]
then
  echo "Some parameter value is empty. Usage: container-init.sh <hadoop_version> <hdfs_path> <log_path> <(The # of)slaves>"
  exit 1
fi

if [[ ! $slaves =~ ^-?[0-9]+$ ]]
then
  echo "The # of slaves are not integer."
  exit 1
elif [[ $slaves -le 1 ]]
then
  slaves=1
elif [[ $slaves -gt 5 ]]
then
  slaves=5
fi

echo "Set docker-compose.yml file."

workers='master
'

for slave in $(seq 1 $slaves)
do
  workers+=slave$slave
  if [[ ! $slave -eq $slaves ]]
  then
    workers+='
'
  fi
done

cat << EOF > workers
$workers
EOF

for slave in $(seq 1 $slaves)
do
  ip_addr+='      - "'slave$slave':10.0.2.'$(($slave + 2))'"
'
done

for slave in $(seq 1 $slaves)
do
  slave_service+='  'slave$slave':
    image: hjben/hadoop:'$hadoop_version'
    hostname: 'slave$slave'
    container_name: 'slave$slave'
    privileged: true
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
    networks:
      hadoop-cluster:
        ipv4_address: 10.0.2.'$(($slave+2))'
    extra_hosts:
      - "master:10.0.0.2"
'$ip_addr
  if [[ ! $slave -eq $slaves ]]
  then
    slave_service+='
'
  fi
done

cat << EOF > docker-compose.yml
services:
  master:
    image: hjben/hadoop:$hadoop_version
    hostname: master
    container_name: master
    privileged: true
    ports:
      - 8088:8088
      - 9870:9870
      - 8042:8042
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
      - $hdfs_path:/data/hadoop
      - $log_path:/usr/local/hadoop/logs
    networks:
      hadoop-cluster:
        ipv4_address: 10.0.2.2
    extra_hosts:
      - "master:10.0.0.2"
$ip_addr
$slave_service
networks:
 hadoop-cluster:
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

docker cp ./workers master:/usr/local/hadoop/etc/hadoop/workers
for slave in $(seq 1 $slaves)
do
  docker cp ./workers slave$slave:/usr/local/hadoop/etc/hadoop/workers
done
echo "Done."

./hadoop-start.sh start