#!/bin/bash

echo "Stop Hadoop service."
docker exec -it master bash -c "/usr/local/hadoop/sbin/stop-all.sh"
echo "Done."