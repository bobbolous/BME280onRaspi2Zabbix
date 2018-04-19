#!/bin/sh
# Script for Monitoring a BME280 connected to Raspberry Pi with Zabbix
# needs bme280.py from Matt Hawkins
# created 2018-04-14 Jan Schoefer
# last revision 2018-04-14 by Jan Schoefer

#change this line in case you have placed the bme280.py somewhere else
bmeScriptPath='/etc/zabbix/scripts/'

case "$1" in 
        chipid)
                # 
                python ${bmeScriptPath}/bme280.py | grep 'Chip ID' | tr -d " " | cut -d ":" -f 2
                ;;
        chipversion)
                # 
                python ${bmeScriptPath}/bme280.py | grep 'Version' | tr -d " " | cut -d ":" -f 2
                ;;
        temperature)
                # 
				python ${bmeScriptPath}/bme280.py | grep 'Temperature' | tr -d " " | tr -d "C" | cut -d ":" -f 2
                ;;
		pressure)
                # 
				python ${bmeScriptPath}/bme280.py | grep 'Pressure' | tr -d " "| tr -d "hPa" | cut -d ":" -f 2
                ;;
		humidity)
                # 
				python ${bmeScriptPath}/bme280.py | grep 'Humidity' | tr -d " "| tr -d "%" | cut -d ":" -f 2
                ;;
		*)
        echo "Usage: $N {chipid|chipversion|temperature|pressure|humidity}" >&2
esac
exit 0
