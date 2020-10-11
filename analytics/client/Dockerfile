FROM python:3.8.0-alpine

MAINTAINER Leon

RUN apk update && apk add \
  build-base \
  linux-headers

WORKDIR /var/lib/vastai_analytics

ADD ./requirements.txt /var/lib/vastai_analytics

RUN python -m pip install -r requirements.txt

ADD . /var/lib/vastai_analytics

CMD ["python", "/var/lib/vastai_analytics/client.py"]
