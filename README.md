# rpi-mosquitto

Docker image with [mosquitto](https://mosquitto.org) service for raspberry pi.

## Environment

* __USER_ID__ uid to assign the mosquitto user that runs the mosquitto MQTT broker. Default 9001.
* __GROUP_ID__ gid to assign the mosquitto user that runs the mosquitto MQTT broker. Default 9001.

## Volumes

* __/mosquitto/log__ Log files.
* __/mosquitto/data__ Persistence data.
* __/mosquitto/conf__ Configuration files for the mosquitto mqtt broker.

## Exposed Ports

* __1883__ Default listener for mosquitto broker.
* __9001__ Listener for websocket connections.

## Run the Container

```no-highlight
docker run \
    --name mosquitto \
    -v /opt/mosquitto/conf:/mosquitto/conf \
    -v /opt/mosquitto/data:/mosquitto/data \
    -v /opt/mosquitto/log:/mosquitto/log \
    -p 1883:1883 \
    -p 9001:9001 \
    -e USER_ID=<uid> \
    -e GROUP_ID=<gid> \
    -d \
    --restart=always \
    bjosa/rpi-mosquitto
```
Replace `<uid>` and `<gid>` with the uid and gid of the user that should run the mosquitto MQTT message broker in the container.
