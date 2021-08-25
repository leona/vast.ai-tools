#!/bin/sh

source /app/functions.sh

OUT_PATH=/app/output
cores=$(nproc)
gpu_count=`nvidia-smi --query-gpu=name --format=csv,noheader | wc -l`

rm -rf $OUT_PATH/*
mkdir -p $OUT_PATH

# CPU test
log_wrap \
    "cpu" \
    "stress-ng --cpu $cores --timeout $BENCH_TIME --metrics-brief -q -Y $OUT_PATH/cpu.yml && cat $OUT_PATH/cpu.yml | yq '.metrics[0].\"bogo-ops-per-second-usr-sys-time\"'"

# Drive stress test
log_wrap \
    "hd_test" \
    "stress-ng --hdd 5 --hdd-ops 1000000 -q"

# Drive speed test
log_wrap \
    "hd_speed" \
    "dd if=/dev/zero of=/tmp/output bs=8k count=10k 2>&1 | tail -n 1"

# Drive sequential read speed
log_wrap \
    "hd_sequential_read" \
    "fio --name TEST --eta-newline=5s --filename=fio-tempfile.dat --rw=read --size=500m --io_size=10g --blocksize=1024k --ioengine=libaio --fsync=10000 --iodepth=32 --direct=1 --numjobs=1 --runtime=60 --group_reporting 2> /dev/null > $OUT_PATH/hd_sequential_read.log"

# Drive sequential write speed
log_wrap \
    "hd_sequential_write" \
    "fio --name TEST --eta-newline=5s --filename=fio-tempfile.dat --rw=write --size=500m --io_size=10g --blocksize=1024k --ioengine=libaio --fsync=10000 --iodepth=32 --direct=1 --numjobs=1 --runtime=60 --group_reporting 2> /dev/null > $OUT_PATH/hd_sequential_write.log"

# Drive speed Vast metric
log_wrap \
    "hd_vast_speed" \
    "hdparm -t / 2> /dev/null > $OUT_PATH/hd_vast_speed.log"

# Memory stress test
log_wrap \
    "mem_stress" \
    "stress-ng --vm 1 --vm-bytes 75% --vm-method all --verify -t $BENCH_TIME -v -q "

# Memory test
log_wrap\
     "mem_test" \
     "sysbench --test=memory --memory-block-size=1M --memory-total-size=10G run 2> /dev/null > $OUT_PATH/mem.log"

# Hashcat MD5 Test
log_wrap \
    "hashcat_md5" \
    "hashcat.bin -b -m 0 --quiet 2> /dev/null > $OUT_PATH/hashcat_md5.log"

# Hashcat SHA-512 Test
log_wrap\
     "hashcat_sha_512" \
     "hashcat.bin -b -m 17600 --quiet 2> /dev/null > $OUT_PATH/hashcat_sha_512.log"

# GPU Bandwith test
log_wrap\
     "gpu_bandwith" \
     "bandwidthTest --memory=pinned --device all --csv 2> /dev/null > $OUT_PATH/gpu_bandwith.log"

# GPU DL Test
log_wrap\
     "gpu_dl_test" \
     "python3 pytorch_bench.py --NUM_GPU $gpu_count --BATCH_SIZE 6 --NUM_CLASSES 500 --NUM_TEST 10 --folder $OUT_PATH/pytorch 2> /dev/null > /dev/null"
