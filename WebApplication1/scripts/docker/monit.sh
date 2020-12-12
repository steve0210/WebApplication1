#!/usr/bin/env bash

SERVICE=svc
APP=${SERVICE}_app
FILE=/etc/monit.d/$SERVICE.conf
APP_START=/var/www/$SERVICE/current/script/docker.sh

if [ -f $FILE ]; then
  mv $FILE{,.backup}
fi

cat > $FILE <<EOF
check process $SERVICE with pidfile "/var/run/docker-monit/${APP}.pid"
  start program = "$APP_START start"
  stop program = "$APP_START stop"
EOF
