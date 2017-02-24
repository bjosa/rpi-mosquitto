FROM multiarch/debian-debootstrap:armhf-jessie

# Set variables
ENV WORK_DIR="/mosquitto" \
    DEBIAN_FRONTEND=noninteractive

# Basic build-time metadata as defined at http://label-schema.org
LABEL org.label-schema.license="MIT" \
    org.label-schema.name="rpi-mosquitto" \
    org.label-schema.description="mosquitto MQTT broker for raspberry pi" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/bjosa/rpi-mosquitto.git"

RUN apt-get update && apt-get install --no-install-recommends  -y \
    wget \
    apt-utils \
    && rm -rf /var/lib/apt/lists/*

# Install mosquitto
RUN wget -q -O - http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add -
RUN wget -q -O /etc/apt/sources.list.d/mosquitto-jessie.list http://repo.mosquitto.org/debian/mosquitto-jessie.list
RUN apt-get update && apt-get install --no-install-recommends -y \
    mosquitto \
    && rm -rf /var/lib/apt/lists/*

COPY conf /mosquitto/conf
COPY conf /mosquitto/conf.template
VOLUME ["/mosquitto/conf", "/mosquitto/data", "/mosquitto/log"]

# Execute command
WORKDIR ${WORK_DIR}
EXPOSE 1883 9001
COPY entrypoint.sh /
RUN chmod 766 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-c", "/usr/sbin/mosquitto -c /mosquitto/conf/mosquitto.conf"]
