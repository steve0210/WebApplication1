#!/bin/sh

SERVICE=app
APP=${SERVICE}_app
PROJ=${SERVICE}_project
ACTION=${1:-stop}
DIR=/var/run/docker-monit
FILE=$DIR/$APP.pid
COMP_FILE=/var/www/${SERVICE}/current/scripts/docker-compose.yml
COMPOSE_ARGS="-p $PROJ -f $COMP_FILE"

RUNNING=$(docker inspect -f '{{.State.Running}}' $APP 2> /dev/null || echo 'false')

mkdir -p $DIR

if [ "${RUNNING//[$'\t\r\n']}" == "false" ]; then 
  echo "$APP not running"; 
else 
  su - rails -c "docker-compose $COMPOSE_ARGS down"
fi

[ -f "$FILE" ] && echo "Removing pid file with $(cat $FILE)" && rm $FILE
if [ "$ACTION" != "start" ]; then exit; fi
  
if su - rails -c "docker-compose $COMPOSE_ARGS up -d"; then
  pid=$(docker inspect -f '{{.State.Pid}}' $APP 2> /dev/null || echo '0')
  if [ "${pid//[$'\t\r\n']}" != "0" ]; then
    echo $pid > $FILE
    echo "Creating pid file with $(cat $FILE)"
  fi
fi

echo "logs: docker-compose $COMPOSE_ARGS logs"
