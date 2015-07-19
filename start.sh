#!/bin/bash

###################
# Run this script to create and run your InfluxDB container.
###################

#### Configuration ####
IMAGE_NAME="hervenicol/influxdb"
IMAGE_TAG="0.8.8"
CONT_NAME="influxdb"
EXPOSED_PORT_PROTOBUF="38099"
EXPOSED_PORT_RAFT="38090"
EXPOSED_PORT_API="38086"
EXPOSED_PORT_ADMIN="38083"
EXPOSED_PORT_COLLECTD=25826
#### End Configuration ####

docker run -d -i -t \
	-p "$EXPOSED_PORT_PROTOBUF":8099 \
	-p "$EXPOSED_PORT_RAFT":8090 \
	-p "$EXPOSED_PORT_API":8086 \
	-p "$EXPOSED_PORT_ADMIN":8083 \
	-p "$EXPOSED_PORT_COLLECTD":25826/udp \
	--name "$CONT_NAME" \
	"$IMAGE_NAME":"$IMAGE_TAG" && \
wget -O- -w 5 "http://localhost:$EXPOSED_PORT_API/db/site_dev/users?u=root&p=root" &&
sleep 2 &&
wget -O- -w 5 "http://localhost:$EXPOSED_PORT_API/db?u=root&p=root" --post-data '{"name": "collectd"}'

