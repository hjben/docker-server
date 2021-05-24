#!/bin/bash

echo "Start Zookeeper web server."
docker exec -it zk-web bash -c "cd zk-web && lein run"