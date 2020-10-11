docker build --tag nxie/vast-analytics .
docker push nxie/vast-analytics

docker run \
  --name vast-analytics -d \
  -e DB_HOST=0.0.0.0 \
  -e DB_USER=root \
  -e DB_PASSWORD=password \
  -e DB_NAME=vast \
  -e VAST_MACHINE_ID=1234 \
  -e VAST_USERNAME=email@example.com \
  -e VAST_PASSWORD=password \
  -e LOG_SYS_INTERVAL=10 \
  -e LOG_ACC_INTERVAL=30 \
  nxie/vast-analytics
