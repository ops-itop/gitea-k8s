#!/bin/sh

[ "$GITEA_WORK_DIR"x == ""x ] && GITEA_WORK_DIR=/data
[ "$USER"x == ""x ] && USER=git

CONF=$GITEA_WORK_DIR/custom/conf

[ ! -d $CONF ] && sudo mkdir -p $CONF

sudo cp -f $APP_CONFIG_PATH/CONFIG $CONF/app.ini

sudo chown -R git:git /data

export GITEA_WORK_DIR
export USER

exec /gitea web