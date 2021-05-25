#!/bin/bash

echo "Start Livy service."
docker exec -it spark bash -c "livy-server start"