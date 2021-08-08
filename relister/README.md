## Relister

This script runs on your Vast machine once a day and sets its available until date for X number of days away. Prices are also a scale of the current mining profitability.

#### Set config
Edit .vast_relister to set your config options and move it to the correct path
```bash
mv .vast_relister /root/.vast_relister
```

#### Test
```bash
bash relister.sh
```

#### Setup cron
Runs at 1am everyday
```bash
echo "0 1 * * * bash /root/relister/relister.sh" | tee -a /var/spool/cron/crontabs/root
```
