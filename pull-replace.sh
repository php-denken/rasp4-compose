#!/bin/bash
set -ex

source config.cfg

git pull
cp -f docker-compose.yml.template docker-compose.yml

sed -i "s/###RASPBERRY_HOST_IP###/$RASPBERRY_HOST_IP/" docker-compose.yml
