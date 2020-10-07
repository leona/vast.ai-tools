#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -o allexport
source $DIR/.env

PARAM=$1

if [ "$PARAM" == "chat_id" ]; then
  python $DIR/lib/get_chat_id.py
  exit
fi

python $DIR/lib/server.py
