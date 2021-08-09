# Load config
source /root/.vast_relister

# Set API key if not exists
cat /root/.vast_api_key

if [ "$?" != "0" ]; then
  echo "Copying API key"
  cp /var/lib/vastai_kaalia/api_key /root/.vast_api_key
fi

# Update vast-cli
if [ "$AUTO_UPDATE_CLI" == "yes" ]; then
  echo "Updating vast-cli"
  wget https://raw.githubusercontent.com/leona/vast-python/master/vast.py -O /usr/local/bin/vast
  chmod +x /usr/local/bin/vast
fi

# Get most profitable reward
base_hashrate=90.5
btc_reward=$(curl -s https://whattomine.com/coins.json | jq '[.coins[]]|max_by(.profitability24).btc_revenue24')

if [ "$?" != "0" ] || [ "$?" == "null" ]; then
  echo "Failed to get most profitable reward"
  exit 1
fi

btc_reward="${btc_reward%\"}"
btc_reward="${btc_reward#\"}"

# Get scaled USD price based off set hashrate
usd_btc="$(curl -s https://blockchain.info/ticker | jq '.USD.last')"

if [ "$?" != "0" ] || [ "$?" == "null" ]; then
  echo "Failed to get BTC price"
  exit 1
fi

mining_profit=$(echo "scale=10; (((${usd_btc} * ${btc_reward}) / $base_hashrate) * $HASHRATE) / 24" | bc)
scaled_price=$(echo "$mining_profit * $MINING_SCALE" | bc)

# Get list till date
timestamp=$(date +%s)
end_date=$(echo "$timestamp + (60 * 60 * 24 * $NUM_DAYS)" | bc)

# List machine
/usr/local/bin/vast list machine $MACHINE_ID --price_gpu $scaled_price --price_disk $PRICE_DISK --price_inetu $PRICE_INETU --price_inetd $PRICE_INETD --end_date $end_date
