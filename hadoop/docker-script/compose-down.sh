#!/bin/bash

echo "Remove all containers."
docker-compose down
sleep 1

rm -f workers
rm -f docker-compose.yml
echo "Done."