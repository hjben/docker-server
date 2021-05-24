#!/bin/bash

echo "Start Jupyter-lab service."
docker exec -it jupyter-lab bash -c "jupyter lab"