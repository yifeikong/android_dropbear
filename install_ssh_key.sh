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

echo "安装sshd"
adb -s $serial push ~/.ssh/dev.id_rsa.pub /data/local/new_key
adb -s $serial shell "cat /data/local/new_key >> /data/local/authorized_keys"
adb -s $serial shell "rm /data/local/new_key"
adb -s $serial push ~/.ssh/id_rsa.pub /data/local/new_key
adb -s $serial shell "cat /data/local/new_key >> /data/local/authorized_keys"
adb -s $serial shell "rm /data/local/new_key"

echo "关闭锁屏密码"
ssh -o StrictHostKeyChecking=no root@$1 "sqlite3 /data/system/locksettings.db \"UPDATE locksettings SET value = '1' WHERE name = 'lockscreen.disabled'\""
ssh -o StrictHostKeyChecking=no root@$1 "sqlite3 /data/system/locksettings.db \"UPDATE locksettings SET value = '0' WHERE name = 'lockscreen.password_type_alternate'\""
ssh -o StrictHostKeyChecking=no root@$1 "sqlite3 /data/system/locksettings.db \"UPDATE locksettings SET value = '0' WHERE name = 'lockscreen.password_type'\""

adb -s $serial shell reboot
