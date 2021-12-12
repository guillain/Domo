# OpenHABian

1. [Installation](#installation)
    1. [Download the last version](#download-the-last-version)
    2. [Summary](#summary)
2. [Post installation](#post-installation)
    1. [Upgrade](#upgrade)
    2. [Hostname](#hostname)
    3. [System locale](#system-locale)
    4. [Password](#password)
    5. [Disable Wifi](#disable-wifi)
    6. [Uninstall ZRam](#uninstall-zram)
3. [Addons](#addons)
    1. [Log viewer](#log-viewer)
    2. [Mosquitto](#mosquitto---mqtt-broker)
    3. [NTP server](#ntp-server)
4. [Tuning](#tuning)
    1. [Firewall](#firewall)
    2. [External wifi board](#external-wifi-board)

## Installation

Install [OpenHabian](https://www.openhab.org/docs/installation/openhabian.html), the OpenHAB distribution for Raspberry
device.

Follow each steps define in this documentation:
https://www.openhab.org/docs/installation/openhabian.html#raspberry-pi-prepackaged-sd-card-image

### Download the last version

release: [https://github.com/openhab/openhabian/releases](https://github.com/openhab/openhabian/releases)

### Summary

1. Download the latest "openHABian" SD card image file (opens new window)(Note: the file is xz compressed)
2. Write the image to your SD card (e.g. with Etcher (opens new window)or official Raspberry Pi Imager (opens new
   window), both able to directly work with xz files
3. Insert the SD card into your Raspberry Pi, connect your Ethernet cable - Wi-Fi is also supported - and power on
4. Wait approximately 15-45 minutes for openHABian to do its magic, you can watch the install progress from within your
   browser.
5. The system will be accessible by its IP or via the local DNS name openhabian (or whatever you changed 'hostname' in
   openhabian.conf to)
6. Connect to the openHAB UI at http://openhabian:8080(opens new window)
7. Connect to the Samba network shares(opens new window)
8. Connect to the openHAB Log Viewer (frontail): http://openhabian:9001(opens new window)

At the end, connect through SSH for the next step and to preset with your own settings the Py.

- username: openhabian
- password: openhabian

## Post installation

Finalise the installation by applying your hardening with the help of CLI menu of the tools `openhabian-config`:

`$ sudo openhabian-config`

### Upgrade

> 02 | Upgrade System

### Hostname

> 31 | Change hostname => **domo**

### System locale

> 32 | Set system locale

> | Enable NTP

### Password

Select all users for a first test (mean, don't miss user!)
> 34 | Change passwords

### Disable Wifi

In fact it will be managed by RaspAP.
> 37 | WiFi setup

> | Disable WiFi

### Uninstall ZRam

> 38 | Uninstall  zram

## Addons

### Log viewer

Install it from the menu of the CLI tools `openhabian-config` :
> 21 | Log Viewer

### Mosquitto - MQTT broker

Install it from the menu of the CLI tools `openhabian-config` :
> 23 | Mosquitto

Configure all necessary _users_ such as:

   ````commandline
sudo mosquitto_passwd -b /etc/mosquitto/passwd MosquittoOpenHAB _PASSWORD_
sudo mosquitto_passwd -b /etc/mosquitto/passwd MosquittoESP _PASSWORD_
sudo mosquitto_passwd -b /etc/mosquitto/passwd MosquittoNoeRED _PASSWORD_
sudo mosquitto_passwd -b /etc/mosquitto/passwd MosquittoRFID _PASSWORD_
````

_Tips_: You can add the Mosquitto's logs in the Log viewer ;)

_Tips_: If you have an issue to reach the MQTT port outside of the Py, try the following commands:

````commandline
sudo echo 'listener 1883' >> /etc/mosquitto/mosquitto.conf
sudo systemctl restart mosquitto
````

### NTP server
Always useful to be on time!
````commandline
sudo apt-get -y install ntp
````

And configure the server:
````commandline
echo "
server 0.europe.pool.ntp.org
server 1.europe.pool.ntp.org
server 2.europe.pool.ntp.org
server 3.europe.pool.ntp.org
restrict 10.1.1.0
" >> /etc/ntp.conf
sudo service ntp restart
sudo service ntp status
````

Remember to install and configure the client on other endpoints if required:
````commandline
sudo apt-get install ntpdate`
echo "server 10.1.1.1 prefer iburst" >> /etc/ntp/conf && sudo service ntp restart
ntpq -ps
````

## Tuning

### Firewall

Can be useful to have a firewall...

Rules for **TCP** only.

````commandline
sudo apt-get install ufw
sudo ufw enable
sudo ufw allow 22     # SSH
sudo ufw allow 53     # DNS
sudo ufw allow from any to any port 123 proto udp # NTP
sudo ufw allow 139    # NetBIOS/SMB
sudo ufw allow 445    # SMB
sudo ufw allow 80     # HTTP - RaspAP
sudo ufw allow 1883   # MQTT - Mosquitto <> OpenHAB, ESP
sudo ufw allow 5007   # HTTP - OpenHAB
sudo ufw allow 8080   # HTTP - OpenHAB
sudo ufw allow 8101   # HTTP - OpenHAB
sudo ufw allow 8443   # HTTPS - OpenHAB
sudo ufw allow 9001   # HTTP - Log viewer
````

### External wifi board

If you have a dedicated Wifi board, remember to deactivate it properly:

````commandline
$ sudo echo 'dtoverlay=disable-wifi' >> /boot/config.txt`
$ sudo echo 'dtoverlay=disable-bt' >> /boot/config.txt`
````

And maybe to install dedicated driver:

- Wifi USB dongle - rtl8812au

````commandline
git clone https://github.com/gnab/rtl8812au.git
cd rtl8812au
sed -i 's/CONFIG_PLATFORM_I386_PC = y/CONFIG_PLATFORM_I386_PC = n/g' Makefile
sed -i 's/CONFIG_PLATFORM_ARM_RPI = n/CONFIG_PLATFORM_ARM_RPI = y/g' Makefile
sudo bash install.sh
````

- Wifi USB dongle - rtl88x2bu

````commandline
git clone https://github.com/cilynx/rtl88x2bu.git
cd rtl88x2bu
sed -i 's/I386_PC = y/I386_PC = n/' Makefile
sed -i 's/ARM_RPI = n/ARM_RPI = y/' Makefile

    - DKMS as above
        VER=$(sed -n 's/\PACKAGE_VERSION="\(.*\)"/\1/p' dkms.conf)
        sudo rsync -rvhP ./ /usr/src/rtl88x2bu-${VER}
        sudo dkms add -m rtl88x2bu -v ${VER}
        sudo dkms build -m rtl88x2bu -v ${VER} # Takes ~3-minutes on a 3B+
        sudo dkms install -m rtl88x2bu -v ${VER}
````
