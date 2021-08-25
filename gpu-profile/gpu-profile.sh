#!/bin/bash

# Require root
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

PARAM=$1

if ! [ -n "$PARAM" ]; then
  echo "You must choose a docker container or set the 'default' e.g. gpu-profile nxie/aio-miner"
  exit
fi

config_root=/etc/gpu-profile/config

if [ "$PARAM" = "default" ]; then
  config_path="$config_root/default.conf"
else
  config_path="$config_root/$PARAM.conf"
fi

if test -f "$config_path"; then
  source $config_path
  echo "Existing values below"
  echo "CLOCK_SUPPORT=$CLOCK_SUPPORT"
  echo "POWER_LIMIT=$POWER_LIMIT"
  echo "FAN_SPEED=$FAN_SPEED"
  echo "CLOCK_OFFSET=$CLOCK_OFFSET"
  echo "MEM_CLOCK_OFFSET=$MEM_CLOCK_OFFSET"
  echo "To skip and use the saved config press enter for the following"
fi

mkdir -p "$(dirname $config_path)" && touch "$config_path"

read -p "Enter clocks support (3 for 1000 series, 4 for 2000 series cards): " _clock_support
read -p "Enter the power limit in watts (e.g. 250): " _power_limit
read -p "Enter the fan speed or 0 for automatic (e.g. 50): " _fan_speed
echo "NOTE: The following clock offsets apply half of what would apply in windows. 1000 is a 500mhz offset. "
read -p "Enter the clock offset (e.g. 200): " _clock_offset
read -p "Enter the memory offset (e.g. 1000): " _mem_clock_offset

if ! [ -n "$_clock_support" ]; then
  _clock_support=$CLOCK_SUPPORT
  echo "Using existing clock support"
fi

if ! [ -n "$_power_limit" ]; then
  _power_limit=$POWER_LIMIT
  echo "Using existing power limit"
fi

if ! [ -n "$_fan_speed" ]; then
  _fan_speed=$FAN_SPEED
  echo "Using existing fan speed"
fi

if ! [ -n "$_clock_offset" ]; then
  _clock_offset=$CLOCK_OFFSET
  echo "Using existing clock offset"
fi

if ! [ -n "$_mem_clock_offset" ]; then
  _mem_clock_offset=$MEM_CLOCK_OFFSET
  echo "Using existing mem clock offset"
fi

rm -f $config_path
echo "CLOCK_SUPPORT=$_clock_support" >> $config_path
echo "POWER_LIMIT=$_power_limit" >> $config_path
echo "FAN_SPEED=$_fan_speed" >> $config_path
echo "CLOCK_OFFSET=$_clock_offset" >> $config_path
echo "MEM_CLOCK_OFFSET=$_mem_clock_offset" >> $config_path
echo "Config written to $config_path"

ps aux | grep 'gpu-profile-daemon' | awk '{print $2}' | while read daemon_id;
do
  kill $daemon_id
done

gpu-profile-daemon > /var/log/gpu-profile.log 2>&1 &
echo "gpu-profile-daemon restarted"
echo "Finished creating config for $PARAM. Check logs at /var/log/gpu-profile.log"
