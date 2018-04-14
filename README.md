# BME280onRaspi2Zabbix
use this fine tutorial to hook up your BME280 breakout board to your RaspberryPi
https://www.raspberrypi-spy.co.uk/2016/07/using-bme280-i2c-temperature-pressure-sensor-in-python/

## Get Raspberry, I2C and BME280 running
1. connect BME280 to RaspberryPi
1. get I2C running
    + `$ sudo apt install i2c-tools`
    + `$ sudo adduser pi i2c`
    + `$ i2cdetect -y 1`
1. import this python script
    * `$ wget https://bitbucket.org/MattHawkinsUK/rpispy-misc/raw/master/python/bme280.py`
1. adjust the BME280 I2C adress

```
###vanilla bme280.py###
DEVICE = 0x76 # Default device I2C address
#######################
```

```
###modified bme280.py###
DEVICE = 0x77 # own device I2C address
########################
```

## Make Zabbix agent send data to Zabbix Server
- Data send from bme280.py ('Version' is the chip version)
	Chip ID     : 96
	Version     : 0
	Temperature :  23.26 C
	Pressure :  981.696544874 hPa
	Humidity :  39.4967091683 %


- TODO
    - [x] make a script that returns BME280 data truncated as we need it for zabbix_agent
    - [x] Integrate script in zabbix_agent.conf  
	- [ ] Template for Zabbix server frontend that requests/receives data as we like it
	- [ ] Test the whole thing
	
# Thanks to 
*Matt Hawkins for his great BME280 reading tool (bme280.py) written in Python