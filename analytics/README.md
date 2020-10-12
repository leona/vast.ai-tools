docker build --tag nxie/vast-analytics .
docker push nxie/vast-analytics

# Analytics dashboard



## Server setup

The server will host your database and Grafana dashboard.
I recommend a $5 Ubuntu 18.04 server from Vultr. Use my referral link for $100 credit.
https://www.vultr.com/?ref=8581277-6G


### Dependencies & config
```bash
sudo apt install -y docker.io docker-compose
git clone https://github.com/leona/vast.ai-tools.git
cd vast.ai-tools/analytics/server

# Setup config file with a unique password
cp .env.example .env
chmod 755 .env
nano .env
```

### Run
```bash
docker-compose up -d
```
### Run client
```bash
docker run \
  -e DB_HOST=0.0.0.0 \
  -e DB_USER=root \
  -e DB_PASSWORD=password \
  -e DB_NAME=vast \
  -e VAST_MACHINE_ID=1234 \
  -e LOG_SYS_INTERVAL=30 \
  -e LOG_ACC_INTERVAL=60 \
  --gpus all \
  -v /var/lib/docker:/var/lib/docker \
  -v /var/lib/vastai_kaalia/api_key:/var/lib/vastai_analytics/api_key \
  --network host \
  --name vast-analytics -d \
  nxie/vast-analytics
```
