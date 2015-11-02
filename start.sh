#!/bin/bash

###################
# Run this script to create and run your InfluxDB container.
###################

#### Configuration ####
IMAGE_NAME="hervenicol/influxdb"
IMAGE_TAG="0.9.4"
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
	"$IMAGE_NAME":"$IMAGE_TAG"

