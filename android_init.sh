setprop service.adb.tcp.port 5555
stop adbd
start adbd
adb root
dropbear -P /data/local/dropbear.pid -r /data/local/dropbear_host_key -A -N root -C jk -R /data/local/authorized_keys
start-stop-daemon -S --name heartbeatd --pidfile /data/local/heartbeatd.pid --exec /data/local/heartbeatd.sh --background --make-pidfile -- 10.2.0.101:8080
