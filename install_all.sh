#!/bin/bash

if [ -z $1 ]; then
    echo "need ip"
fi

for file in init.apk dropbearmulti android_init.sh heartbeatd.sh; do
    if [ ! -f $file ]; then
        echo $file file not found
        exit 1
    fi
done

echo "是否已配置android_init.sh中的服务器IP？任意键继续"

read y


ip=$1

adb connect $ip

adb -s $ip root
adb -s $ip remount
adb -s $ip push android_init.sh /data/local/init.sh

adb -s $ip push heartbeatd.sh /data/local/heartbeatd.sh
adb -s $ip shell chmod 755 /data/local/heartbeatd.sh

adb -s $ip push dropbearmulti /data/local/dropbearmulti
adb -s $ip shell mount -o remount,rw /system /system
adb -s $ip shell cp /data/local/dropbearmulti /system/xbin/dropbearmulti
adb -s $ip shell ln -s /system/xbin/dropbearmulti /system/xbin/dropbear
adb -s $ip shell ln -s /system/xbin/dropbearmulti /system/xbin/dropbearkey
adb -s $ip shell ln -s /system/xbin/dropbearmulti /system/xbin/scp
adb -s $ip shell ln -s /system/xbin/dropbearmulti /system/xbin/dbclient
adb -s $ip shell chmod 0755 /system/xbin/dropbearmulti
adb -s $ip push ~/.ssh/id_rsa.pub /data/local/authorized_keys
adb -s $ip shell dropbearkey -t rsa -f /data/local/dropbear_host_key

curl https://www.busybox.net/downloads/binaries/latest/busybox-armv7l -o busybox
adb -s $ip push busybox /data/local/busybox
adb -s $ip shell mount -o remount,rw /system /system
adb -s $ip shell cp /data/local/busybox /system/xbin/busybox
adb -s $ip shell chmod 0755 /system/xbin/busybox
adb -s $ip shell /system/xbin/busybox --install /system/xbin

adb -s $ip install init.apk
echo "请在安全中心打开init.apk自动启动和root权限"
