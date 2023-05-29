#!/bin/bash

airflow_version=$1
workers=$2
dag_path=$3
log_path=$4
airflow_user=$5
airflow_password=$6
maria_root_password=$7
maria_data_path=$8

if [ -z $maria_data_path ]
then
  echo "Some parameter value is empty. Usage: compose-up.sh <airflow_version> <(The # of) workers [integer]> <dag_path> <log_path> <airflow_user> <airflow_password> <mariaDB_root_password> <mariaDB_data_path>"
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

echo "Set docker-compose.yml file."

for worker in $(seq 1 $workers)
do
  ip_addr+='      - "'worker$worker':10.0.2.'$(($worker + 7))'"
'
done

for worker in $(seq 1 $workers)
do
  airflow_service+='  'worker$worker':
    image: hjben/airflow:'$airflow_version'
    hostname: 'worker$worker'
    container_name: 'worker$worker'
    cgroup: host
    privileged: true
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
      - '$dag_path':/usr/local/airflow/dags
      - '$log_path'/worker'$worker':/usr/local/airflow/logs
    networks:
      airflow-cluster:
        ipv4_address: 10.0.2.'$(($worker + 7))'
    extra_hosts:
      - "mariadb:10.0.2.2"
      - "jupyter-lab:10.0.2.3"
      - "redis:10.0.2.4"
      - "webserver:10.0.2.5"
      - "scheduler:10.0.2.6"
      - "flower:10.0.2.7"
'$ip_addr
  if [[ ! $worker -eq $workers ]]
  then
    airflow_service+='
'
  fi
done

cat << EOF > docker-compose.yml
services:
  mariadb:
    image: hjben/mariadb:10.5
    hostname: mariadb
    container_name: mariadb
    cgroup: host
    privileged: true
    ports:
      - 3306:3306
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
      - $maria_data_path:/var/lib/mysql 
    environment:
      MARIADB_ROOT_PASSWORD: $maria_root_password
    networks:
      airflow-cluster:
        ipv4_address: 10.0.2.2
    extra_hosts:
      - "mariadb:10.0.2.2"
      - "jupyter-lab:10.0.2.3"
      - "redis:10.0.2.4"
      - "webserver:10.0.2.5"
      - "scheduler:10.0.2.6"
      - "flower:10.0.2.7"
$ip_addr
  jupyter-lab:
    image: hjben/jupyter-lab:latest
    hostname: jupyter-lab
    container_name: jupyter-lab
    cgroup: host
    privileged: true
    ports:
      - 8888:8888
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
      - $dag_path:/root/workspace
    networks:
      airflow-cluster:
        ipv4_address: 10.0.2.3
    extra_hosts:
      - "mariadb:10.0.2.2"
      - "jupyter-lab:10.0.2.3"
      - "redis:10.0.2.4"
      - "webserver:10.0.2.5"
      - "scheduler:10.0.2.6"
      - "flower:10.0.2.7"
$ip_addr
  redis:
    image: hjben/redis:latest
    hostname: redis
    container_name: redis
    cgroup: host
    privileged: true
    ports:
      - 6379:6379
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
    networks:
      airflow-cluster:
        ipv4_address: 10.0.2.4
    extra_hosts:
      - "mariadb:10.0.2.2"
      - "jupyter-lab:10.0.2.3"
      - "redis:10.0.2.4"
      - "webserver:10.0.2.5"
      - "scheduler:10.0.2.6"
      - "flower:10.0.2.7"
$ip_addr
  webserver:
    image: hjben/airflow:$airflow_version
    hostname: webserver
    container_name: webserver
    cgroup: host
    privileged: true
    ports:
      - 28080:8080
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
      - $log_path:/usr/local/airflow/logs
    networks:
      airflow-cluster:
        ipv4_address: 10.0.2.5
    extra_hosts:
      - "mariadb:10.0.2.2"
      - "jupyter-lab:10.0.2.3"
      - "redis:10.0.2.4"
      - "webserver:10.0.2.5"
      - "scheduler:10.0.2.6"
      - "flower:10.0.2.7"
$ip_addr
  scheduler:
    image: hjben/airflow:$airflow_version
    hostname: scheduler
    container_name: scheduler
    cgroup: host
    privileged: true
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
      - $log_path:/usr/local/airflow/logs
      - $dag_path:/usr/local/airflow/dags
    networks:
      airflow-cluster:
        ipv4_address: 10.0.2.6
    extra_hosts:
      - "mariadb:10.0.2.2"
      - "jupyter-lab:10.0.2.3"
      - "redis:10.0.2.4"
      - "webserver:10.0.2.5"
      - "scheduler:10.0.2.6"
      - "flower:10.0.2.7"
$ip_addr
  flower:
    image: hjben/airflow:$airflow_version
    hostname: flower
    container_name: flower
    cgroup: host
    privileged: true
    ports:
      - 5555:5555
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
    networks:
      airflow-cluster:
        ipv4_address: 10.0.2.7
    extra_hosts:
      - "mariadb:10.0.2.2"
      - "jupyter-lab:10.0.2.3"
      - "redis:10.0.2.4"
      - "webserver:10.0.2.5"
      - "scheduler:10.0.2.6"
      - "flower:10.0.2.7"
$ip_addr
$airflow_service
networks:
 airflow-cluster:
  ipam:
   driver: default
   config:
   - subnet: 10.0.2.0/24
EOF
echo "Done."

echo "Docker-compose container run."
echo "Remove old containers."
docker compose down --remove-orphans
sleep 1

echo "Create new containers."
docker compose up -d
sleep 1
echo "Done."

cat << EOF > init-airflow.sql
CREATE DATABASE airflow_db CHARACTER SET UTF8mb3 COLLATE utf8_general_ci;
EOF

docker cp init-airflow.sql mariadb:/sh/
docker exec -it mariadb bash -c "chmod 755 /sh/init-airflow.sql"

rm -f init-airflow.sql

echo "Initialize Airflow MetaDB."
docker exec -it mariadb bash -c "/sh/init.sh"

echo "Password is required to set Meta database."
docker exec -it mariadb bash -c "mysql -u root -p < /sh/init-airflow.sql"

docker exec -it webserver bash -c "airflow db init"
echo "Done."

echo "Initialize Airflow user."
docker exec -it webserver bash -c "airflow users create --username $airflow_user --firstname Hyunjoong --lastname Kim --role Admin --password $airflow_password --email hj.ben.kim@gmail.com"

./redis-start.sh
