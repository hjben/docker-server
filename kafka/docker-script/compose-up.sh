#!/bin/bash

kafka_version=$1
cmak_version=$2
servers=$3
zookeeper_connect=$4
external_ip=$5
jupyter_workspace_path=$6
data_path=$7
log_path=$8

if [ -z $log_path ]
then
  echo "Some parameter value is empty. Usage: compose-up.sh <kafka_version> <cmak_version> <(The # of) servers [integer]> <zookeeper_connect> <external_ip> <jupyter_workspace_path> <data_path> <log_path>"
  exit 1
fi

if [[ ! $servers =~ ^-?[0-9]+$ ]]
then
  echo "The # of servers is not integer."
  exit 1
elif [[ $servers -le 1 ]]
then
  servers=1
elif [[ $servers -gt 5 ]]
then
  servers=5
fi

echo "Set docker-compose.yml file."

for server in $(seq 1 $servers)
do
  ip_addr+='      - "'kafka$server':10.0.2.'$(($server + 3))'"
'
done

for server in $(seq 1 $servers)
do
  kafka_service+='  'kafka$server':
    image: hjben/kafka:'$kafka_version'
    hostname: 'kafka$server'
    container_name: 'kafka$server'
    privileged: true
    ports:
      - '$((9092+($server)))':'$((9092+($server)))'
    environment:
      KAFKA_ADVERTISED_LISTENERS: INTERNAL://kafka'$server':9092,EXTERNAL://'$external_ip':'$((9092+($server)))'
      KAFKA_LISTENERS: INTERNAL://:9092,EXTERNAL://:'$((9092+($server)))'
      KAFKA_ZOOKEEPER_CONNECT: '$zookeeper_connect'/kafka
      JMX_PORT: 9999
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
      - '$log_path'/kafka'$server':/usr/local/kafka/logs
      - '$data_path':/kafka
    networks:
      kafka-cluster:
        ipv4_address: 10.0.2.'$(($server+3))'
    extra_hosts:
      - "jupyter-lab:10.0.2.2"
      - "cmak:10.0.2.3"
'$ip_addr
  if [[ ! $server -eq $servers ]]
  then
    kakfa_service+='
'
  fi
done

cat << EOF > docker-compose.yml
services:
  jupyter-lab:
    image: hjben/jupyter-lab:latest
    hostname: jupyter-lab
    container_name: jupyter-lab
    privileged: true
    ports:
      - 8888:8888
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
      - $jupyter_workspace_path:/root/workspace
    networks:
      kafka-cluster:
        ipv4_address: 10.0.2.2
    extra_hosts:
      - "jupyter-lab:10.0.2.2"
      - "cmak:10.0.2.3"
$ip_addr
  cmak:
    image: hjben/cmak:$cmak_version
    hostname: cmak
    container_name: cmak
    privileged: true
    ports:
      - 9000:9000
    environment:
      ZK_HOSTS: $zookeeper_connect
      APPLICATION_SECRET: "random-secret"
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
    networks:
      kafka-cluster:
        ipv4_address: 10.0.2.3
    extra_hosts:
      - "jupyter-lab:10.0.2.2"
      - "cmak:10.0.2.3"
$ip_addr
$kafka_service
networks:
 kafka-cluster:
  ipam:
   driver: default
   config:
   - subnet: 10.0.2.0/24
     gateway: 10.0.2.1
EOF
echo "Done."

echo "Docker-compose container run."
# echo "Remove old containers."
# docker-compose down --remove-orphans
# sleep 1

echo "Create new containers."
docker-compose up -d
sleep 1
echo "Done."

./cmak-start.sh clean