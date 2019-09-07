#!/bin/sh

[ "$GITEA_WORK_DIR"x == ""x ] && GITEA_WORK_DIR=/data
[ "$USER"x == ""x ] && USER=git

CONF=$GITEA_WORK_DIR/custom/conf

[ ! -d $CONF ] && sudo mkdir -p $CONF

# log 目录不存在时 dump 不成功
[ ! -d $GITEA_WORK_DIR/log ] && mkdir -p $GITEA_WORK_DIR/log

sudo cp -f $APP_CONFIG_PATH/CONFIG $CONF/app.ini

sudo chown -R git:git /data

export GITEA_WORK_DIR
export USER

[ -f $APP_CONFIG_PATH/CRON ] && sudo cp $APP_CONFIG_PATH/CRON /etc/crontabs/root

sudo chmod +x /dump.sh

sudo crond -l 0 -d 0
exec /gitea web
