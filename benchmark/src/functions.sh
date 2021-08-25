#!/bin/sh

xlog() {
    echo -e "$1\t$2"
    echo -e "$1\t$2" >> $OUT_PATH/general.log
}

function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

log_wrap() {
    local key=$1
    local cmd=$2
    xlog "${key}_start" "$(uptime)"
    local output="$(bash -c "$cmd")"

    if [ -n "$output" ]; then
        xlog "${key}_output" "$output"
    fi

    xlog "${key}_finish" "$(uptime)"
    echo -e "\nSleeping for ${SLEEP_TIME}s\n"
    sleep ${SLEEP_TIME}s
}

get_cpu_temp() {
    #if ROOT 
       # IPMI
   # else 
        temp=$(sensors | grep "CPUTIN" | awk '{ print $2 }')
    #fi
}