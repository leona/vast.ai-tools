Here are some example arguments you can pass through vast
```bash
nbminer/nbminer -d 0 -a kawpow -o stratum+tcp://kawpow.usa.nicehash.com:3385 -u youraddress.9:d=3072
```
```bash
phoenixminer/PhoenixMiner <see_miner_docs>
```
```bash
ethminer/ethminer <see_miner_docs>
```

There is also the `unique_miner` helper for differentiating workers. Variables it can use are `gpu_bus_id` and `gpu_uuid`.

Example
```bash
unique_miner phoenixminer/PhoenixMiner -pool stratum+ssl://eth-de.flexpool.io:5555 -wal yourwallet.vast_1_gpu_uuid -pool2 stratum+ssl://eth-eu1.nanopool.org:9433
```
