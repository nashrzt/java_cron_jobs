#!/bin/bash

#conditions

#the modules are talking to redis

#purpose of the script isif the tcp connections are not in established state, 
#then kill the running process and restart the module
REDIS_CONNECTION="(ESTABLISHED)"
PROCESS=`sudo lsof -t -i:9696`
REDIS_STATUS=`lsof -p $PROCESS |grep ":6379" |awk '{ print $10 }' |head -1`
service=email-sync
subject="$service at BRAINBLOX PRODUCTION was not running"
email=nishan.pa@razorthink.net



RESULT=`netstat -na | grep 9696 | awk '{print $7}' | wc -l`
if [ "$RESULT" = 0 ]; then

sh /ebs/apps/inblox/scripts/email-sync.sh &

elif [[ $REDIS_STATUS != $REDIS_CONNECTION ]];then
kill -9 $PROCESS
sh /ebs/apps/inblox/scripts/email-sync.sh &
echo "connection between redis and email-sync is broken... so restarting..." | mail -s "$subject" -t $email

else

	echo "email-sync is running successfully"
fi

