#!/bin/bash

echo "Stop Hbase service."
docker exec -it master bash -c "stop-hbase.sh"
echo "Done."