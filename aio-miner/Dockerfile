FROM nvidia/cuda:11.2.1-devel-ubuntu20.04

MAINTAINER Leon

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /home

# Package and dependency setup
RUN apt-get update \
    && apt-get -y install software-properties-common \
    && apt-get update \
    && apt-get install -y git \
     cmake \
     wget

ARG NBMINER_VER=39.0
ARG ETHMINER_VER=0.19.0
ARG PHOENIX_VER=5.6d

RUN \
  wget https://github.com/NebuTech/NBMiner/releases/download/v${NBMINER_VER}/NBMiner_${NBMINER_VER}_Linux.tgz && \
  tar -zxvf NBMiner_${NBMINER_VER}_Linux.tgz && \
  rm NBMiner_${NBMINER_VER}_Linux.tgz && \
  mv NBMiner_Linux nbminer

RUN \
  wget https://github.com/ethereum-mining/ethminer/releases/download/v${ETHMINER_VER}-alpha.0/ethminer-${ETHMINER_VER}-alpha.0-cuda-9-linux-x86_64.tar.gz && \
  tar -zxvf ethminer-${ETHMINER_VER}-alpha.0-cuda-9-linux-x86_64.tar.gz && \
  rm ethminer-${ETHMINER_VER}-alpha.0-cuda-9-linux-x86_64.tar.gz && \
  mv bin ethminer

RUN \
  wget https://phoenixminer.info/downloads/PhoenixMiner_${PHOENIX_VER}_Linux.tar.gz && \
  tar -zxvf PhoenixMiner_${PHOENIX_VER}_Linux.tar.gz && \
  rm PhoenixMiner_${PHOENIX_VER}_Linux.tar.gz && \
  mv PhoenixMiner_${PHOENIX_VER}_Linux phoenixminer

RUN \
  apt-get update && apt-get install -y nano libpci-dev

ADD unique_miner /usr/local/bin
RUN chmod +x /usr/local/bin/unique_miner

# Env setup
ENV GPU_FORCE_64BIT_PTR=0
ENV GPU_MAX_HEAP_SIZE=100
ENV GPU_USE_SYNC_OBJECTS=1
ENV GPU_MAX_ALLOC_PERCENT=100
ENV GPU_SINGLE_ALLOC_PERCENT=100
