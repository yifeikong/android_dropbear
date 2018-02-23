#!/bin/bash


USAGE="$0 <IP> <机器标号>"

if [ -z $1 ]; then
    echo $USAGE
    exit 1
fi

serial=$1:5555

adb disconnect $serial
sleep 1
adb connect $serial
sleep 1
gtimeout 5 adb -s $serial root
sleep 1
adb connect $serial
sleep 1
adb -s $serial remount
sleep 1

echo "安装init.sh"
adb -s $serial push android_init.sh /data/local/init.sh

gtimeout 3 adb -s $serial shell reboot
