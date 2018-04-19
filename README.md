# BME280onRaspi2Zabbix
This repository is intended to provide a way to use Zabbix Server as a frontend for data collected from a BME280 environment sensor connected to a RaspberryPi. CAUTION: SOME OF THE SETTINGS / PERMISSIONS MADE, MAY BE NOT SECURE. You will need (this is intended for / tested with) the following:
+ Raspberry Pi 3 Model B with
    + Raspbian GNU/Linux 9.4 (stretch)
	+ BME280 breakout board
	+ some wires
+ Zabbix Server on a different machine in the same network (you can also install Zabbix Server on the same RaspberryPi)
    + instructions on how to install Zabbix Server are not included

Use this great [tutorial](https://www.raspberrypi-spy.co.uk/2016/07/using-bme280-i2c-temperature-pressure-sensor-in-python/) to hook up your BME280 breakout board to your RaspberryPi


## Get Raspberry, I2C, BME280 and Zabbix Agent running
1. enable I2C through `sudo raspi-config` -> 'Interfacing Options' -> 'P5 I2C' -> 'Yes'
1. connect BME280 to RaspberryPi
1. get I2C running
    + `$ sudo apt update`
    + `$ sudo apt install i2c-tools`
    + `$ sudo adduser pi i2c`
	+ reboot so `/dev/i2c-1` is created
    + `$ i2cdetect -y 1`
1. install python (and SMBus library)
	+ ´sudo apt install python python-smbus´
1. import this python script
    * `$ wget https://bitbucket.org/MattHawkinsUK/rpispy-misc/raw/master/python/bme280.py`
1. adjust the BME280 I2C adress (see section below)
1. install Zabbix Agent
    + `$ sudo apt install zabbix-agent`
1. move the script and change permissions 
    + `$ sudo mkdir /etc/zabbix/scripts/`
    + `$ sudo mv bme280.py /etc/zabbix/scripts/`
	CAUTION: THIS MIGHT BE A SECURITY ISSUE IF YOU ARE IN AN UNSECURE NETWORK:
	+ `$ sudo chmod a+x /etc/zabbix/scripts/bme280.py`
1. import wrapper script
	* `$ wget https://raw.githubusercontent.com/bobbolous/BME280onRaspi2Zabbix/master/bme280_wrapper.sh`
1. move the script and change permissions
    + `$ sudo mv bme280_wrapper.sh /etc/zabbix/scripts/`
	+ `$ sudo chmod a+x /etc/zabbix/scripts/bme280_wrapper.sh`
1. integrate wrapper script in zabbix_agentd.conf (see section below)
1. change permissions for i2c device (CAUTION: THIS MIGHT BE A SECURITY ISSUE IF YOU ARE IN AN UNSECURE NETWORK)
	+ $ sudo chmod o+rw /dev/i2c-1
1. Test bme280.py (see section below)
1. Test bme280_wrapper.sh (see section below)
1. Test zabbix through zabbix_get (see section below)
1. Create/Modify host within Zabbix Server frontend. 
   + Import and assign template 'zbx_Template_BME280.xml' aka 'Template BME280'.
   + be aware you use correct Host Name (as stated within 'zabbix_agentd.conf') and correct IP
	
## Adjusting BME280 I2C adress
```
$ i2cdetect -y 1
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- 77
```

```
sudo nano bme280.py
```

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

## Integrate script in zabbix_agentd.conf
This section includes the parameters/items you may have to adjust when using a vanilla zabbix_agentd.conf. Parameters that are not mentioned here may be used with their default value.

` sudo nano /etc/zabbix/zabbix_agentd.conf`

```
###recommended items in zabbix_agentd.conf###
# your server IP (where your Zabbix frontend lives)
# add 127.0.0.1 if you want to test with zabbix_get from the same machine
Server=<yourZabbixServerIP>,127.0.0.1

# your server IP (where your zabbix frontend lives)
# add 127.0.0.1 if you want to test with zabbix_get from the same machine
ServerActive=<yourZabbixServerIP>,127.0.0.1

# the same you used as name for Host wihtin the Zabbix frontend
Hostname=<HostName>

# path to the bme280_wrapper.sh script
UserParameter=bme280_wrapper.sh[*],/etc/zabbix/scripts/bme280_wrapper.sh $1
#############################################
```

## Test output of bme280.py
Data send from bme280.py ('Version' is the chip version):
```
$ /etc/zabbix/scripts/bme280.py
Chip ID     : 96
Version     : 0
Temperature :  21.02 C
Pressure :  992.664409933 hPa
Humidity :  44.8311472966 %

```	
## Test output of bme280_wrapper.sh
```
$ /etc/zabbix/scripts/bme280_wrapper.sh temperature
21.02
```

## Test zabbix through zabbix_get
Exchange '127.0.0.1' with your client IP (Raspi with BME) when running this commands from a different machine  (e.g. your Zabbix Server)
+ `$ sudo apt install zabbix-server-pgsql`

```
$ zabbix_get -s 127.0.0.1 -k bme280_wrapper.sh[temperature]
21.02
```
	
# Thanks to 
*Matt Hawkins for his great BME280 reading tool (bme280.py) written in Python