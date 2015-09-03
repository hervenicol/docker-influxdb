#!/bin/bash

###################
# Run this script to build a Docker image from the git tree.
###################

#### Configuration ####
IMAGE_NAME="hervenicol/influxdb"
IMAGE_TAG="0.9.3"
#### End configuration ####

docker build --force-rm=true -t "$IMAGE_NAME":"$IMAGE_TAG" .

