#!/bin/bash

su - git

DATE=`date +%Y%m%d-%H%M%S`
FILE="gitea-dump-$DATE.zip"
TEMPDIR="/tmp"
CONFIG="/data/custom/conf/app.ini"

cd /data
/gitea dump --file $FILE --tempdir $TEMPDIR --config $CONFIG &>/tmp/gitea-dump.log
