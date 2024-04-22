#!/bin/bash

echo "Start Redis service."
docker exec -it redis bash -c "/redis-init.sh"
