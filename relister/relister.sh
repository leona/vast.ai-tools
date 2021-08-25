#!/bin/bash

# Load config
source /root/.vast_relister

# Check for API key
API_KEY=$(cat /var/lib/vastai_kaalia/api_key)
API_ENDPOINT=https://vast.ai/api/v0

if [ "$?" != "0" ]; then
  echo "API key does not exist at /var/lib/vastai_kaalia/api_key"
  exit 1
fi

# Get most profitable reward
base_hashrate=90.5
btc_reward=$(curl -s https://whattomine.com/coins.json | jq '[.coins[]]|max_by(.profitability24).btc_revenue24')

if [ "$?" != "0" ] || [ "$btc_reward" == "null" ]; then
  echo "Failed to get most profitable reward"
  exit 1
fi

# Clean up quotes
btc_reward="${btc_reward%\"}"
btc_reward="${btc_reward#\"}"

# Get scaled USD price based off set hashrate
usd_btc="$(curl -s https://blockchain.info/ticker | jq '.USD.last')"

if [ "$?" != "0" ] || [ "$usd_btc" == "null" ]; then
  echo "Failed to get BTC price"
  exit 1
fi

mining_profit=$(echo "scale=10; (((${usd_btc} * ${btc_reward}) / $base_hashrate) * $HASHRATE) / 24" | bc)
scaled_price=$(printf "%3.2f\n" $(echo "$mining_profit * $MINING_SCALE" | bc))
scaled_defjob_price=$(printf "%3.2f\n" $(echo "$mining_profit * $MINING_DEFJOB_SCALE" | bc))

# Get list till date
timestamp=$(date +%s)
end_date=$(echo "$timestamp + (60 * 60 * 24 * $NUM_DAYS)" | bc)

# List machine
list_data="{\"end_date\":${end_date},\"machine\":$MACHINE_ID,\"min_chunk\":$MIN_CHUNK,\"price_disk\":${PRICE_DISK},\"price_gpu\":${scaled_price},\"price_inetd\":${PRICE_INETD},\"price_inetu\":${PRICE_INETU}}"

curl -s \
  -X PUT \
  -H "Content-Type: application/json" \
  -d "$list_data" \
  ${API_ENDPOINT}/machines/create_asks/?api_key=$API_KEY

machine_info=$(curl -s https://vast.ai/api/v0/machines/?api_key=$API_KEY | jq ".machines[] | select(.id == $MACHINE_ID)")

# Get current image and args_str
if [ "$?" != "0" ]; then
  echo "Failed to get current machine config"
  exit 1
fi

args_str=$(echo "$machine_info" | jq ".bid_image_args_str")
image=$(echo "$machine_info" | jq ".bid_image")

if [ "$args_str" == "null" ] || [ "$image" == "null" ]; then
  echo "Failed to get args string or image"
  exit 1
fi

# Set defjob price
defjob_data="{\"machine\":${MACHINE_ID},\"price_gpu\":${scaled_defjob_price},\"price_inetu\":0,\"price_inetd\":0,\"image\":${image},\"args_str\":${args_str},\"use_ssh\":true}"

curl -s \
  -X PUT \
  -H "Content-Type: application/json" \
  -d "$defjob_data" \
  ${API_ENDPOINT}/machines/create_bids/?api_key=$API_KEY

if [ "$?" != "0" ]; then
  echo "Failed to set defjob price"
  exit 1
fi
