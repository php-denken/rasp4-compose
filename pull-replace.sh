#!/bin/bash
set -ex

source config.cfg

PLACEHOLDER_ARRAY=("RASPBERRY_HOST_IP" "NEXTCLOUD_DB_PW" "NEXTCLOUD_DB_ROOT_PASSWORD" "NEXTCLOUD_DB_USER" "NEXTCLOUD_DB_NAME")

git pull
cp -f docker-compose.yml.template docker-compose.yml

for PLACEHOLDER in ${PLACEHOLDER_ARRAY[*]}
do
    sed -i "s/###$PLACEHOLDER###/${!PLACEHOLDER}/" docker-compose.yml
done
