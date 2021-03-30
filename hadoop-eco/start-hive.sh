#!/bin/bash

docker exec -it mariadb bash -c "systemctl start mariadb"

# docker exec -it mariadb bash -c "/init.sh"
# docker exec -it master bash -c "$HIVE_HOME/bin/schematool -dbType mysql -initSchema"

docker exec -it master bash -c "init-hive-dfs.sh"
docker exec -it master bash -c "hive --service metastore &"
docker exec -it master bash -c "hive --service hiveserver2"
