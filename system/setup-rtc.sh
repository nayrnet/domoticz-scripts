#!/bin/bash
# Set Date from Internet and if fails load RTC
# Put me in /usr/local/sbin and simlink me to /etc/cron.daily

if [ ! -e "/dev/rtc1" ]; then
	echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device
fi
/usr/sbin/ntpdate -b -s -u pool.ntp.org
if [ $? -ne 0 ];then
	if [  -e "/dev/rtc1" ]; then
		echo Setting system time from RTC
		/sbin/hwclock --rtc /dev/rtc1 -s
		exit 0
	fi
else
	if [  -e "/dev/rtc1" ]; then
		echo Writing Internet time to RTC
		/sbin/hwclock --rtc /dev/rtc1 -w
		exit 0
	fi
fi
exit 1
