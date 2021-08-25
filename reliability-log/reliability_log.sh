#!/bin/bash

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -m|--machine_id) machine_id="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

shopt -s lastpipe

if [ -z "$machine_id" ]; then
    echo "-m or --machine-id missing"
    exit 1
fi

api_key=$(cat /var/lib/vastai_kaalia/api_key)

if [[ "$?" != "0" ]]; then
    echo "API Key not found"
    exit 1
fi

curl --compressed -m 5 --silent -L https://vast.ai/api/v0/machines/?api_key=$api_key \
    | jq ".machines[] | select(.id==$machine_id) | .reliability2" \
    | read reliability

if [[ "$?" != "0" ]]; then
    echo "Reliability check failed"
    logger "vast_reliability failed"
    exit 1
fi

echo "Reliability: $reliability"
logger "vast_reliability $reliability"