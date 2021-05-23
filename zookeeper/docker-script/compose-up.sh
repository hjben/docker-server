#!/bin/bash

zookeeper_version=$1
servers=$2
web_user=$3
web_password=$4
data_path=$5
log_path=$6


if [ -z $log_path ]
then
  echo "Some parameter value is empty. Usage: compose-up.sh <zookeeper_version> <(The # of ensemble)servers [odd number]> <web_user> <web_password> <data_path> <log_path>"
  exit 1
fi

if [[ ! $servers =~ ^-?[0-9]+$ ]]
then
  echo "The # of ensemble servers is not integer."
  exit 1
elif [[ $servers -le 1 ]]
then
  servers=1
elif [[ $servers -gt 5 ]]
then
  servers=5
fi

if [[ $servers -eq 2 ]] || [[ $servers -eq 4 ]]
then
  echo "THe # of ensemble servers must be odd number"
  exit 1
fi

echo "Set docker-compose.yml file."


for server in $(seq 1 $servers)
do
  ip_addr+='      - "'zoo$server':10.0.3.'$(($server + 2))'"
'
done

for server in $(seq 1 $servers)
do
  zoo_service+='  'zoo$server':
    image: hjben/zookeeper:'$zookeeper_version'
    hostname: 'zoo$server'
    container_name: 'zoo$server'
    privileged: true
    ports:
      - '$((2181+($server-1)))':2181
    environment:
      MYID: '$server'
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
      - '$log_path'/zoo'$server':/usr/local/zookeeper/logs
      - '$data_path'/zoo'$server':/data
    networks:
      zookeeper-cluster:
        ipv4_address: 10.0.3.'$(($server+2))'
    extra_hosts:
      - "zk-web:10.0.3.2"
'$ip_addr
  if [[ ! $server -eq $servers ]]
  then
    zoo_service+='
'
  fi
done

cat << EOF > docker-compose.yml
services:
  zk-web:
    image: hjben/zk-web:latest
    hostname: zk-web
    container_name: zk-web
    privileged: true
    ports:
      - 18080:8080
    environment:
      USER: $web_user
      PASS: $web_password
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
    networks:
      zookeeper-cluster:
        ipv4_address: 10.0.3.2
    extra_hosts:
      - "zk-web:10.0.3.2"
$ip_addr
$zoo_service
networks:
 zookeeper-cluster:
  ipam:
   driver: default
   config:
   - subnet: 10.0.3.0/24
     gateway: 10.0.3.1
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

echo "Initialize Zookeeper."
for server in $(seq 1 $servers)
do
  docker exec zoo$server zkInit.sh
done

docker exec zk-web /sh/set-user.sh
echo "Done."

./zookeeper-start.sh $servers start