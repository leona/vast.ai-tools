#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $DIR/.env

WORKER=$1

if ! [ -n "$WORKER" ]; then
  WORKER="unknown-worker"
fi

while [ 1 ]
do
  request_url="http://$SERVER_ADDR:$SERVER_PORT/ping/$WORKER?api_key=$API_KEY"
  time=`date "+%H:%M:%S-%d/%m/%Y"`
  echo "$time - Pinging $request_url"
  curl -m 2 "$request_url"
  sleep $PING_INTERVAL
done
