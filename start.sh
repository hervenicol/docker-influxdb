#!/bin/bash

###################
# Run this script to create and run your InfluxDB container.
###################

#### Configuration ####
IMAGE_NAME="hervenicol/influxdb"
IMAGE_TAG="0.8.8"
CONT_NAME="influxdb"
#PORT_PROTOBUF="8099"
#PORT_RAFT="8090"
PORT_API="8086"
PORT_ADMIN="8083"
PORT_COLLECTD=25826
#### End Configuration ####


echo "Starting Docker container $CONT_NAME"
docker run -d -i -t \
	-p "$PORT_API":8086 \
	-p "$PORT_ADMIN":8083 \
	-p "$PORT_COLLECTD":25826/udp \
	--name "$CONT_NAME" \
	"$IMAGE_NAME":"$IMAGE_TAG" &&

echo "Container $CONT_NAME started; now waiting for service to be up"  &&
wget -q -O/dev/null -w 5 "http://localhost:$PORT_API/db/site_dev/users?u=root&p=root" &&

echo "Container $CONT_NAME up and running; now creating collectd database" &&
sleep 2 &&
wget -q -O- -w 5 "http://localhost:$PORT_API/db?u=root&p=root" --post-data '{"name": "collectd"}' &&

echo "$CONT_NAME ready to use!" ||
echo "$CONT_NAME failed starting up!"

