#!/bin/bash

MOSQUITTO_USER_ID=${USER_ID:-9001}

echo "Changing uid of user mosquitto to ${MOSQUITTO_USER_ID}"
OLD_MOSQUITTO_USER_ID=$(id -u mosquitto)
usermod -u ${MOSQUITTO_USER_ID} mosquitto   

echo "Set ${WORK_DIR} folder permission"
chown -R mosquitto ${WORK_DIR}

if [ -z "$(ls -A "${WORK_DIR}/conf")" ]; then
    # Copy configuration template
    echo "No configuration found... initializing."
    cp -av "${WORK_DIR}/conf.template/." "${WORK_DIR}/conf/"
fi

echo "Starting mosquitto..."

exec "$@"
