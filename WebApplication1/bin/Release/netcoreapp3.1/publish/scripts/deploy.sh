#!/bin/sh

SSH_SERVER=asbw
PUBLISH_DIR=./bin/Release/netcoreapp3.1/publish
APPLICATION=ccapi
APP_DIR=/var/www/$APPLICATION
TIMESTAMP=$(date "+%Y%m%d%H%M%S")
RELEASE_PATH=$APP_DIR/releases/$TIMESTAMP
CURRENT_PATH=$APP_DIR/current

if [ -f $HOME/.psbashrc ]; then . $HOME/.psbashrc; fi

ssh $SSH_SERVER <<ENDSSH
cd $APP_DIR
[ ! -d shared/log ] && mkdir -p shared/{certs,log}
[ ! -d releases ] && mkdir releases
ENDSSH

echo "Publishing from $PUBLISH_DIR to $RELEASE_PATH"
scp -r $PUBLISH_DIR $SSH_SERVER:$RELEASE_PATH

for f in entrypoint docker_int docker monit docker_compose; do 
  FILES="$FILES docker/${f}.sh"
done

echo "Installing in $RELEASE_PATH/scripts"
ssh $SSH_SERVER <<ENDSSH
cd $RELEASE_PATH/scripts
chmod +x \$(find . -name '*.sh')
FILES="$FILES" ./docker/env.sh production $APPLICATION
for file in default $APPLICATION; do
  ln -sr ./nginx/etc/conf.d/{sites-available/\${file}.conf,sites-enabled}
done
./docker/docker_compose.sh
docker-compose build $APPLICATION

echo "Creating symlink $CURRENT_PATH"
[ -L $CURRENT_PATH ] && rm $CURRENT_PATH
ln -s $RELEASE_PATH $CURRENT_PATH
ENDSSH
