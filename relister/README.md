## Relister

This script runs on your Vast machine once a day and updates the price and instance expiry date. Price is based off a scale of the current mining profit for your GPU, expiry date is the number of days contracts have before you can set a new price.

### Set config
Edit `.vast_relister` to set your config options and move it to the correct path
```bash
mv .vast_relister /root/.vast_relister
```

### Test
```bash
bash relister.sh
```

### Setup cron
Runs at 1am everyday
```bash
echo "0 1 * * * bash /root/relister/relister.sh >> /var/log/relister.log 2>&1" | tee -a /var/spool/cron/crontabs/root
```
