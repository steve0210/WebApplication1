#!/usr/bin/env bash

SERVICE=svc
APP=${SERVICE}_app
IMG=${SERVICE}:latest
DIR=$(pwd)
APP_DIR=$(dirname $DIR)
HTTP_PORT=5000
SHARED_DIR=/var/www/$SERVICE/shared
ENTRY_DIR=/var/www/$SERVICE/current
NETWORK=$(docker network ls | grep bridge | head -n 1 | awk '{ print $2}')

cp -r ~/.{ssh,pgpass} . 
sed -i -e 's#\\\\#/#' $APP_DIR/appsettings.json
for file in .dockerignore Dockerfile; do mv ./$file ../; done

FILE=./docker-compose.yml
echo "Creating $FILE"
cat > $FILE <<EOF
version: "3.8"

services:
  $SERVICE:
    image: $IMG
    build: $APP_DIR
    container_name: $APP
    command: $ENTRY_DIR/scripts/docker/entrypoint.sh
    tty: true
    volumes:
      - "$SHARED_DIR/log:${ENTRY_DIR}/log"
    extra_hosts:
      - AppMailer:10.210.11.16
      - AppMailer.sonichealthcareusa.com:10.210.11.16
    expose:
      - "$HTTP_PORT"
    networks:
      - $NETWORK
  reverse:
    container_name: reverse
    image: nginx
    ports:
      - 80:80
      - 443:443
    volumes:
      - $DIR/nginx/etc/nginx.conf:/etc/nginx/nginx.conf
      - $DIR/nginx/etc/conf.d:/etc/nginx/conf.d
      - $SHARED_DIR/certs:/etc/ssl/private
    networks:
      - $NETWORK
networks:
  ${NETWORK}:
    external: true
EOF

FILE=./docker/bashrc

echo "Modifying $FILE"
for var in JWE_IV \
  JWE_SECRET_KEY; do 
  val=$(eval "echo \$$var")
  if [ -n "$val" ]; then 
    echo "export $var=\"$val\"" >> $FILE
  fi
done
