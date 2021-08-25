# Benchmarking

This contains the source for `nxie/aio-benchmark` which is a Docker image to run a collection of benchmark/stress tools.

#### List of tests
```bash
stress-ng - CPU stress
stress-ng - Drive stress
stress-ng - Memory stress
sysbench - Memory latency and speed benchmark
dd - Drive speed benchmark
Hashcat - MD5 Benchmark
Hashcat - SHA-512 Benchmark
bandwithTest - GPU bandwith benchmark
pytorch - Pytorch DL  benchmark
```

#### Run using default settings
Results are saved to ./output.

```bash
docker run -v ${PWD}/output:/app/output --shm-size 1G --rm -it --gpus all nxie/aio-benchmark
```

#### Run with params SLEEP_TIME/BENCH_TIME 
```bash
docker run -v ${PWD}/output:/app/output --shm-size 1G --rm -it -e SLEEP_TIME=2 -e BENCH_TIME=2 --gpus all nxie/aio-benchmark
```

#### Test
```bash
docker run --shm-size 1G --rm -it --gpus all nxie/aio-benchmark /bin/bash
```

#### Build
```bash
docker build -t nxie/aio-benchmark .
```



