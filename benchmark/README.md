# Benchmarking

This readme will be updated with benchmarking utilities as I come across them.

RTX 3090 Benchmarking
```bash
sudo docker run --gpus all -it --shm-size=1g --ulimit memlock=-1 --rm nvcr.io/nvidia/tensorflow:20.09-tf1-py3 bash -c 'git clone https://github.com/u39kun/deep-learning-benchmark && cd deep-learning-benchmark && python benchmark.py -f tensorflow'
```

Other Benchmarking
```bash
sudo nvidia-docker run --rm  --name bench --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --env NVIDIA_VISIBLE_DEVICES=0,1 -it  nvcr.io/nvidia/tensorflow:17.12 /bin/bash

git clone https://github.com/u39kun/deep-learning-benchmark && cd deep-learning-benchmark && python benchmark.py -f tensorflow
```
