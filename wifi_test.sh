#! /system/bin/sh


sleep 1
num=0

while true;
do

cp /sdcard/pudu/log/kernel/log/kernel.log /sdcard/pudu/log/kernel/log/wifi_connect_kernel.log

wlan0_info=$(ifconfig |grep wlan0)
echo "${wlan0_info}"
wlan0=${wlan0_info:0:5}

if [ "$wlan0" != "wlan0" ];then
svc wifi enable
fi

#svc wifi enable
sleep 30
ping -i 0.3 -c 10 www.baidu.com
if [ $? -eq 0 ];then
num=0
count=$(cat /sdcard/wifi_count.txt)

let count++
echo $count > /sdcard/wifi_count.txt
if [ count -eq 100 ];then
echo "pass" >> /sdcard/wifi_count.txt
break
fi
sleep 5
svc wifi disable
sleep 10

else
sleep 30
ping -i 0.3 -c 10 www.baidu.com
if [ $? -eq 0 ];then
echo "fail $count" > /sdcard/wifi_connect_again_count.txt
cp /sdcard/pudu/log/kernel/log/kernel.log /sdcard/pudu/log/kernel/log/wifi_connect_fail_kernel.log
sleep 10
else
count=$(cat /sdcard/wifi_count.txt)
echo "fail $count" > /sdcard/wifi_count.txt
cp /sdcard/pudu/log/kernel/log/kernel.log /sdcard/pudu/log/kernel/log/wifi_connect_fail_kernel.log
break
fi

fi
done
