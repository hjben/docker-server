#!/bin/bash

echo "Stop Livy service."
docker exec -it spark bash -c "livy-server stop"