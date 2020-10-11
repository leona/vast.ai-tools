#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -o allexport
source $DIR/.env

run_account() {
  while [ 1 ]
  do
    python3.8 $DIR/client.py account
    sleep "${LOG_ACC_INTERVAL}s"
  done
}

run_system() {
  while [ 1 ]
  do
    python3.8 $DIR/client.py system
    sleep "${LOG_SYS_INTERVAL}s"
  done
}

run_system &
run_account
