#!/system/bin/sh

HOST=$1
RETRY_COUNT=10
RETRY_INTERVAL=10
SLEEP=600

while [ 1 ]; do
    ok=""
    for i in `seq $RETRY_COUNT`; do 
        ip=`netcfg | grep wlan | awk '{print $3;}' | cut -d'/' -f1`
        echo "`date` heart beat with http://$HOST/heartbeat/$ip @$i"
        if wget -s -T 10 http://$HOST/heartbeat/$ip; then
            ok="1"
            break
        fi
        sleep $RETRY_INTERVAL
    done
    if [ -z $ok ]; then
        echo "`date` error connecting $HOST, will reboot now"
        reboot
    fi
    sleep $SLEEP
done >> /data/local/heartbeatd.log

