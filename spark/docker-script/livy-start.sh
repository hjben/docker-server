#!/bin/bash

echo "Start Livy service."
docker exec -it master bash -c "livy-server start"