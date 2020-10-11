#!/bin/bash

# Run
# sudo screen -dmS docker-events ./log_docker_events.sh

while [ 1 ]
do
  docker events --format "{{json .}}" | while read line; do
    echo `date "+%H:%M:%S-%d/%m/%Y"`
    echo $line
  done
done
