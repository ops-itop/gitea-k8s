#!/bin/bash

DATE=`date +%Y%m%d-%H%M%S`
FILE="gitea-dump-$DATE.zip"
TEMPDIR="/tmp"
[ "$GITEA_WORK_DIR"x == ""x ] && GITEA_WORK_DIR=/data
BACKUP=$GITEA_WORK_DIR/backups
CONFIG="$GITEA_WORK_DIR/custom/conf/app.ini"

cd $GITEA_WORK_DIR
/gitea dump --file $FILE --tempdir $TEMPDIR --config $CONFIG


CONTENT=`file $FILE`
echo $CONTENT |grep "Zip archive data" && r=SUCC || r=FAILED
CONTENT="$CONTENT\n`du -sh $FILE`"

[ ! -d $BACKUP ] && mkdir -p $BACKUP
mv $FILE $BACKUP

# 删除过期备份
# 备份默认保留30天
[ "$RETAIN"x == ""x ] && RETAIN=30
cd $BACKUP

DELDAY=`date -d "$RETAIN day ago" +%Y%m%d`
FILE_DATE=`ls gitea-dump-*.zip |awk -F'-' '{print $3}'`

for f in ${FILE_DATE};do
	if [ $f -lt $DELDAY ];then
		del="gitea-dump-$f-*.zip"
		msg="delete $del"
		CONTENT="$CONTENT\n$msg"
		echo $msg
		rm -f $del
	fi
done

# 通知
function notify() {
	# 使用邮件接口发送 https://github.com/ops-itop/mailer
	[ "$NOTIFYAPI"x == ""x ] && NOTIFYAPI="http://127.0.0.1/api/mail"
	[ "$TOS"x == ""x ] && echo "NEED param tos , exit ..." && exit 1
	curl -s $NOTIFYAPI -XPOST -d "tos=$TOS&subject=[$1] Gitea Dump Result($DATE)&content=$2"
}

notify $r "$CONTENT"
