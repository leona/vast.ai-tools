#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -o allexport
source $DIR/.env

get_container_property() {
  arg="${1}"
  key="${2}"
  container_id="${3}"

  docker inspect -f "{{range \$index, \$value := $arg}}{{if eq (index (split \$value \"=\") 0) \"$key\" }}{{range \$i, \$part := (split \$value \"=\")}}{{if gt \$i 1}}{{print \"=\"}}{{end}}{{if gt \$i 0}}{{print \$part}}{{end}}{{end}}{{end}}{{end}}" $container_id
}

run_account() {
  while [ 1 ]
  do
    python3.8 $DIR/client.py --action account
    sleep "${LOG_ACC_INTERVAL}s"
  done
}

run_system() {
  while [ 1 ]
  do
    python3.8 $DIR/client.py --action system
    sleep "${LOG_SYS_INTERVAL}s"
  done
}

run_docker() {
  while [ 1 ]
  do
    docker events --format "{{json .}}" | while read line; do
      status=$(echo "$line" | jq -r .status)
      container_id=$(echo "$line" | jq -r .id)
      time=$(echo "$line" | jq -r .time)

      if [ "$status" = "start" ]; then
        image_name="$(docker inspect -f '{{ .Config.Image }}' $container_id)"
        echo "$status ran - Time: $time - image: $image_name - Container: $container_id"
        gpu_id=$(get_container_property ".Config.Env" "NVIDIA_VISIBLE_DEVICES" $container_id)
        python3.8 $DIR/client.py --action event --name docker_start --time "$time" --values "$container_id,$image_name,$gpu_id"
      fi

      if [ "$status" = "destroy" ]; then
        echo "$status ran - Time: $time - Container: $container_id"
        python3.8 $DIR/client.py --action event --name docker_destroy --time "$time" --values "$container_id"
      fi
    done
  done
}

run_docker &
run_system &
run_account
