#!/bin/bash

echo "Stop Livy service."
docker exec -it master bash -c "livy-server stop"