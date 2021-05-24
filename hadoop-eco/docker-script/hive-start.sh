#!/bin/bash

flag=$1

if [ -z $flag ]
then
  flag="none"
fi

echo "Start Hive service."

if [ $flag = "meta" ] || [ $flag = "all" ] ; then
  echo "Initialize Hive MetaDB."
  docker exec -it mariadb bash -c "/sh/init.sh"
  
  echo "Password is required to set Meta database and user."
  docker exec -it mariadb bash -c "mysql -u root -p < /sh/init-hive.sql"
  docker exec -it master bash -c "/usr/local/hive/bin/schematool -dbType mysql -initSchema"
  echo "Done."
else
  docker exec -it mariadb bash -c "/sh/start.sh"
fi

if [ $flag = "hdfs" ] || [ $flag = "all" ] ; then
  echo "Initialize HDFS for Hive."
  docker exec -it master bash -c "init-hive-dfs.sh"
  echo "Done."
fi

echo "Start Hive server."
docker exec -it master bash -c "hive --service metastore &"
docker exec -it master bash -c "hive --service hiveserver2"