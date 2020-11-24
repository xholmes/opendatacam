#!/bin/bash

set -e

# Config variables for network config that can be changed
PLATFORM="desktop"
VIDEO_INPUT="file"
NEURAL_NETWORK="yolov4"
PATH_DARKNET=/var/local/darknet

# Check for docker-compose
command -v docker-compose >/dev/null 2>&1 || { echo >&2 "OpenDataCam requires docker-compose, please install and retry"; }

echo "Building image from scratch"
cd docker/build/desktop
wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.weights
docker build -t opendatacam_desktop .
# Remove the weights as it would have already been copied into the image
rm yolov4.weights

echo "Setting up default configuration"
cd ../../run/desktop
cp ../../../config.json .

echo "Replace config file with platform default params ... (you can change those later)"
echo "NEURAL_NETWORK : $NEURAL_NETWORK"
echo "VIDEO_INPUT : $VIDEO_INPUT"

sed -i'.bak' -e "s/TO_REPLACE_VIDEO_INPUT/$VIDEO_INPUT/g" config.json
sed -i'.bak' -e "s/TO_REPLACE_NEURAL_NETWORK/$NEURAL_NETWORK/g" config.json

sed -i'.bak' -e "s|TO_REPLACE_PATH_TO_DARKNET|$PATH_DARKNET|g" config.json

