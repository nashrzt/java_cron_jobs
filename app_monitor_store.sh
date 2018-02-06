#!/bin/bash

#conditions

#the modules are talking to redis

#purpose of the script isif the tcp connections are not in established state, 
#then kill the running process and restart the module
REDIS_CONNECTION="(ESTABLISHED)"
PROCESS=`sudo lsof -t -i:9093`
REDIS_STATUS=`lsof -p $PROCESS |grep ":6379" |awk '{ print $10 }' |head -1`
service=store
subject="$service at BRAINBLOX PRODUCTION was not running"
email=nishan.pa@razorthink.net



RESULT=`netstat -na | grep 9093 | awk '{print $7}' | wc -l`
if [ "$RESULT" = 0 ]; then

sh /ebs/apps/inblox/scripts/store.sh &

elif [[ $REDIS_STATUS != $REDIS_CONNECTION ]];then
kill -9 $PROCESS
sh /ebs/apps/inblox/scripts/store.sh &
echo "connection between redis and store is broken... so restarting..." | mail -s "$subject" -t $email

else

	echo "store is running successfully"
fi

