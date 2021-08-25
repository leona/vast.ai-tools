# Vast.ai tools

This repository will be updated with scripts and other assets used for managing vast.ai servers.

## Analytics dashboard

This is an analytics dashboard for remotely monitoring system information as well as tracking earnings.

[Link to read more](./analytics)

## GPU Profile switcher

Lets you create profiles for power limit, fan speed and clocks. Have a default one for renters and container specific ones for your jobs.

[Link to read more](./gpu-profile)

## Uptime monitor

Receive messages via Telegram if your machine goes down

[Link to read more](./uptime-monitor)

## Stats

Aggregated stats on all active machines

[Link to read more](./stats)

## Benchmarking (WIP)

This contains the source for `nxie/aio-benchmark` which is a Docker image to run a collection of benchmark/stress tools.

[Link to read more](./benchmark)

## aio-miner

This contains the Dockerfile for the image `nxie/aio-miner`

[Link to read more](./aio-miner)

## Relister

Automatically lists your machine every day for a set number of days away. This helps for expiring contracts. Also sets your price based on a scale of mining profitibility.

[Link to read more](./relister)

## Ideas

Some things I'd like to make when I have time

- Simple mining profitability switcher
- Bid watcher. Watch for GPUs that reach a certain price per hour and rent them automatically
