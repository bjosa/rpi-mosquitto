#!/bin/bash

MOSQUITTO_USER_ID=${USER_ID:-9001}
MOSQUITTO_GROUP_ID=${GROUP_ID:-9001}

echo "Changing uid and gid of user mosquitto to uid ${MOSQUITTO_USER_ID} and gid ${MOSQUITTO_GROUP_ID}"
OLD_MOSQUITTO_USER_ID=$(id -u mosquitto)
OLD_MOSQUITTO_GROUP_ID=$(id -g mosquitto)
usermod -u ${MOSQUITTO_USER_ID} mosquitto
if grep -q ":${MOSQUITTO_GROUP_ID}:" /etc/group
then
    usermod -g ${MOSQUITTO_GROUP_ID} mosquitto
else
    groupmod -g ${MOSQUITTO_GROUP_ID} mosquitto
fi

echo "Set ${WORK_DIR} folder permission"
chown -R ${MOSQUITTO_USER_ID}:${MOSQUITTO_GROUP_ID} ${WORK_DIR}

if [ -z "$(ls -A "${WORK_DIR}/conf")" ]; then
    # Copy configuration template
    echo "No configuration found... initializing."
    cp -av "${WORK_DIR}/conf.template/." "${WORK_DIR}/conf/"
fi

echo "Starting mosquitto..."

exec "$@"
