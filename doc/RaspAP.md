# RaspAP

1. [Installation](#installation)
    1. [Prerequisites](#prerequisites)
    2. [Install](#install)
2. [First connection](#first-connection)
3. [Configuration](#configuration)

[https://raspap.com/](https://raspap.com/)

## Installation

### Prerequisites

    `$ sudo apt-get -y install git dnsmasq hostapd bc build-essential dkms raspberrypi-kernel-headers`

### Install

    Follow the script instruction:

`$ curl -sL https://install.raspap.com | bash`

`````commandline
lighttpd root: /var/www/html? [Y/n]: y
Complete installation with these values? [Y/n]: y
Enable HttpOnly for session cookies (Recommended)? [Y/n]: y
Enable RaspAP control service (Recommended)? [Y/n]: y
Install ad blocking and enable list management? [Y/n]: y
Install OpenVPN and enable client configuration? [Y/n]: n
The system needs to be rebooted as a final step. Reboot now? [y/N]: y
`````

## First connection

The Quick Installer will complete the steps in the manual installation for you.

Following a reboot, the wireless AP network will be configured as follows:

````commandline
IP address: 10.3.141.1
Username: admin
Password: secret
DHCP range: 10.3.141.50 — 10.3.141.255
SSID: raspi-webgui
Password: ChangeMe
````

Connect on the web GUI to perform the configuration: [http://10.3.141.1/](http://10.3.141.1/)

## Configuration

Apply the following settings:

````commandline
IP address: 10.1.1.1
Username: admin
Password: _OH_PASSWORD_
DHCP range: 10.1.1.200 — 10.1.1.210
SSID: Domo
Password: _SSID_PASSWORD_
DNS 1: 10.1.1.1
````

Plus to do on the GUI:

- Hotspot -> Advanced -> Mask SSID diffusion
- Hotspot -> Advanced -> Maximum client number: 100