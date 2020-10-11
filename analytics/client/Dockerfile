FROM nvidia/driver:440.64.00-ubuntu16.04

MAINTAINER Leon

RUN apt update && apt install -y \
  build-essential \
  software-properties-common \
  wget

RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt update && apt install -y python3.8 python3.8-distutils python3.8-dev
RUN wget https://bootstrap.pypa.io/get-pip.py && python3.8 get-pip.py

WORKDIR /var/lib/vastai_analytics

ADD ./requirements.txt /var/lib/vastai_analytics

RUN python3.8 -m pip install -r requirements.txt

RUN apt install -y apt-transport-https ca-certificates
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce

ADD . /var/lib/vastai_analytics

ENTRYPOINT /bin/bash /var/lib/vastai_analytics/run.sh
