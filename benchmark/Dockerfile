FROM nvidia/cuda:11.1-devel-ubuntu20.04
MAINTAINER Leon
WORKDIR /app
ARG DEBIAN_FRONTEND=noninteractive
ARG HASHCAT_VER=6.2.3
ENV PATH="/app/hashcat-${HASHCAT_VER}:${PATH}"
ENV SLEEP_TIME="60s"
ENV BENCH_TIME="60"

# Package and dependency setup
RUN apt-get update \
    && apt-get -y install software-properties-common \
    && apt-get update \
    && apt-get install -y \
        git \
        cmake \
        wget \
        stress-ng \
        vim \
        python3 \
        python3-pip \
        jq \
        lm-sensors \
        p7zip-full \
        sysbench

RUN pip3 install torchvision==0.9.0+cu111 torch==1.8.0+cu111 -f https://download.pytorch.org/whl/torch_stable.html

RUN wget https://hashcat.net/files/hashcat-${HASHCAT_VER}.7z && \
    7za x hashcat-${HASHCAT_VER}.7z && \
    rm hashcat-${HASHCAT_VER}.7z

RUN git clone https://github.com/NVIDIA/cuda-samples.git && \
    cd cuda-samples/Samples/bandwidthTest && \
    git checkout v11.1 && \
    make && \
    cp /app/cuda-samples/bin/x86_64/linux/release/bandwidthTest /usr/local/bin

RUN pip3 install yq pandas psutil
RUN apt-get -y install fio

ADD src/ /app

CMD ["/bin/bash", "/app/benchmark.sh"]