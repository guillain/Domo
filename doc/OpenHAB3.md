# OpenHab 3

1. [Installation](#installation)
2. [Configuration](#configuration)
    1. [Map transformation](#map-transformation)
    2. [OpenHAB UI](#openhab-ui)
    3. [MQTT Broker](#mqtt-broker)
3. [Templates](#templates)
    1. [Generate your templates](#generate-your-templates)
4. [Links](#links)
5. [Error & Fix](#error--fix)

## Installation

Good news, the application is already included in
the [OpenHABian](https://www.openhab.org/docs/installation/openhabian.html) distribution.

Just logon on the web portal a first time to initialize your account and the global parameters:

[http://domo:8080/auth](http://domo:8080/auth)

_Tips_: Can be interesting to avoid `admin` or `root` as username...

Now add all necessaries addons: `Administration -> Parameters -> [item] -> +`

- Bindings
    - MQTT bindings
    - HTTP Bindings
- Transformations
    - Map
    - JSONPath
    - Javascript
    - RegEx

## Configuration

### Map transformation

Copy the map files in your OpenHab instance:

- Source:
    - `OpenHAB/map/lamp.map`
    - `OpenHAB/map/switch.map`
- Destination:
    - `/etc/openhab/transform/`

They are used by some linked items.

### OpenHAB UI

Create each single page as layout that you need and Ccopy/paste the content of the files generated in
`generated/OpenHAB/web_pages` to populate the source code of each page.

| Main page        | Page name                 | Page type  | File template                                                         |
|------------------|---------------------------|------------|:----------------------------------------------------------------------|
| root             | ESP-32-Cam                | Tabbed     |                                                                       |
| ESP-32-Cam       | ESP-32-Cam-Overview       | Layout     | `generated/OpenHAB/web_pages/ESP_32_Cam/Overview.yml`                 |
| ESP-32-Cam       | 26_Entry                  | Layout     | `generated/OpenHAB/web_pages/ESP_32_Cam/Page_26_Entry.yml`            |
| ESP-32-Cam       | 27_Garage                 | Layout     | `generated/OpenHAB/web_pages/ESP_32_Cam/Page_27_Garage.yml`           |
| ESP-32-Cam       | 28_Garden                 | Layout     | `generated/OpenHAB/web_pages/ESP_32_Cam/Page_28_Garden.yml`           |
| ESP-32-Cam       | 29_Lab32                  | Layout     | `generated/OpenHAB/web_pages/ESP_32_Cam/Page_29_Lab32.yml`            |
| root             | ESP-8266-RFID             | Tabbed     |                                                                       |
| ESP-8266-RFID    | ESP-8266-RFID-Overview    | Layout     | `generated/OpenHAB/web_pages/ESP_8266_RFID/Overview.yml`              |
| ESP-8266-RFID    | 14_Entry                  | Layout     | `generated/OpenHAB/web_pages/ESP_8266_RFID/Page_14_Entry.yml`         |
| root             | ESP-8266-Sensors          | Tabbed     |                                                                       |
| ESP-8266-Sensors | ESP-8266-Sensors-Overview | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Overview.yml`           |
| ESP-8266-Sensors | 15_Entry                  | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_14_Entry.yml`      |
| ESP-8266-Sensors | 16_Livingroom             | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_16_Livingroom.yml` |
| ESP-8266-Sensors | 17_Kitchen                | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_17_Kitchen.yml`    |
| ESP-8266-Sensors | 18_Bathroom               | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_18_Bathroom.yml`   |
| ESP-8266-Sensors | 19_Nina                   | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_19_Nina.yml`       |
| ESP-8266-Sensors | 20_Luca                   | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_20_Luca.yml`       |
| ESP-8266-Sensors | 21_Guestroom             | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_21_Guestroom.yml` |
| ESP-8266-Sensors | 22_Guillain               | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_22_Guillain.yml`   |
| ESP-8266-Sensors | 23_Deskroom               | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_23_Deskroom.yml`   |
| ESP-8266-Sensors | 24_Garage                 | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_24_Garage.yml`     |
| ESP-8266-Sensors | 25_Garden                 | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_25_Garden.yml`     |
| ESP-8266-Sensors | 30_Lab8266                | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_30_Lab8266.yml`    |

### MQTT Broker

Create a MQTT broker thing.

- `Parameters -> Things -> + -> MQTT Binding -> MQTT Broker`
    - Unique ID: **Domo**
    - Label: **Domo MQTT Broker**
    - Hostname: **domo**
    - Advanced:
        - Username: **MosquittoOpenHAB**
        - Password: I let you imagine...

## Templates

### Files

| Component | Sub component | Template file                                              | Generated file                                                         | Comment      |
|-----------|---------------|------------------------------------------------------------|:-----------------------------------------------------------------------|--------------|
| OpenHAB   | API           | `OpenHAB/API/ESP_32_Cam/items_TEMPLATE.json`               | `generated/OpenHAB/API/ESP_32_Cam/items_[ESP_NAME].json`               |              | 
| OpenHAB   | API           | `OpenHAB/API/ESP_32_Cam/links_TEMPLATE.json`               | `generated/OpenHAB/API/ESP_32_Cam/links_[ESP_NAME].json`               |              | 
| OpenHAB   | API           | `OpenHAB/API/ESP_32_Cam/rules_TEMPLATE.json`               | `generated/OpenHAB/API/ESP_32_Cam/rules_[ESP_NAME].json`               |              | 
| OpenHAB   | API           | `OpenHAB/API/ESP_32_Cam/things_TEMPLATE.json`              | `generated/OpenHAB/API/ESP_32_Cam/things_[ESP_NAME].json`              |              | 
| OpenHAB   | API           | `OpenHAB/API/ESP_8266_RFID/items_TEMPLATE.json`            | `generated/OpenHAB/API/ESP_8266_RFID/items_[ESP_NAME].json`            |              | 
| OpenHAB   | API           | `OpenHAB/API/ESP_8266_RFID/links_TEMPLATE.json`            | `generated/OpenHAB/API/ESP_8266_RFID/links_[ESP_NAME].json`            |              | 
| OpenHAB   | API           | `OpenHAB/API/ESP_8266_RFID/rules_TEMPLATE.json`            | `generated/OpenHAB/API/ESP_8266_RFID/rules_[ESP_NAME].json`            |              | 
| OpenHAB   | API           | `OpenHAB/API/ESP_8266_RFID/things_TEMPLATE.json`           | `generated/OpenHAB/API/ESP_8266_RFID/things_[ESP_NAME].json`           |              | 
| OpenHAB   | API           | `OpenHAB/API/ESP_8266_Sensors/items_TEMPLATE.json`         | `generated/OpenHAB/API/ESP_8266_Sensors/items_[ESP_NAME].json`         |              | 
| OpenHAB   | API           | `OpenHAB/API/ESP_8266_Sensors/links_TEMPLATE.json`         | `generated/OpenHAB/API/ESP_8266_Sensors/links_[ESP_NAME].json`         |              | 
| OpenHAB   | API           | `OpenHAB/API/ESP_8266_Sensors/rules_TEMPLATE.json`         | `generated/OpenHAB/API/ESP_8266_Sensors/rules_[ESP_NAME].json`         |              | 
| OpenHAB   | API           | `OpenHAB/API/ESP_8266_Sensors/things_TEMPLATE.json`        | `generated/OpenHAB/API/ESP_8266_Sensors/things_[ESP_NAME].json`        |              |
| OpenHAB   | Web pages     | `OpenHAB/web_pages/ESP_8266_RFID/Overview_HEADER.yml`      | `generated/OpenHAB/web_pages/ESP_8266_RFID/Overview.yml`               |              |
| OpenHAB   | Web pages     | `OpenHAB/web_pages/ESP_8266_RFID/Overview_TEMPLATE.yml`    | `generated/OpenHAB/web_pages/ESP_8266_RFID/Overview_[ESP_NAME].yml`    |              |
| OpenHAB   | Web pages     | `OpenHAB/web_pages/ESP_8266_RFID/Page_TEMPLATE.yml`        | `generated/OpenHAB/web_pages/ESP_8266_RFID/Page_[ESP_NAME].yml`        |              |
| OpenHAB   | Web pages     | `OpenHAB/web_pages/ESP_32_Cam/Overview_HEADER.yml`         | `generated/OpenHAB/web_pages/ESP_32_Cam/Overview.yml`                  |              |
| OpenHAB   | Web pages     | `OpenHAB/web_pages/ESP_32_Cam/Overview_TEMPLATE.yml`       | `generated/OpenHAB/web_pages/ESP_32_Cam/Overview_[ESP_NAME].yml`       |              |
| OpenHAB   | Web pages     | `OpenHAB/web_pages/ESP_32_Cam/Page_TEMPLATE.yml`           | `generated/OpenHAB/web_pages/ESP_32_Cam/Page_[ESP_NAME].yml`           |              | 
| OpenHAB   | Web pages     | `OpenHAB/web_pages/ESP_8266_Sensors/Overview_HEADER.yml`   | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Overview.yml`            |              |
| OpenHAB   | Web pages     | `OpenHAB/web_pages/ESP_8266_Sensors/Overview_TEMPLATE.yml` | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Overview_[ESP_NAME].yml` |              |
| OpenHAB   | Web pages     | `OpenHAB/web_pages/ESP_8266_Sensors/Page_TEMPLATE.yml`     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_[ESP_NAME].yml`     |              |
| HABPanel  | Web pages     | `HABOpen/web_pages/ESP_8266_Sensors/RFID_TEMPLATE.yml`     | `generated/HABOpen/web_pages/ESP_8266_Sensors/RFID_[ESP_NAME].yml`     |              |

### Constants

- ESP_NAME
- ESP_REFERENCE
- ESP_IP_PATTERN
- ESP_IP_ADDRESS
- ESP_IP_SUBNET
- ESP_PASSWORD
- ESP_MQTT_USER
- ESP_MQTT_PASSWORD
- AP_SSID
- AP_SSID_PASSWORD
- OH_WEB_URL

### Generate your templates

To easily prepare the TEMPLATES, you can export your current configuration, clean it and convert it to template.

Below an example that can be used to do it:

````commandline
ESP_PATTERN="My_pattern_to_grabe_one_thing"
for tag in "things" "items" "links" "rules"; do
    # Grabe the current conf
    _curl "GET" ${tag} > ${tag}.json
    
    # Add the key words to be replaced, cf. `provisioning.sh` fct `_sed`
    # - ESP_REFERENCE <> esp_reference
    # - ESP_NAME <> esp_name
    # - ESP_LOCATION <> esp_location
    # - ESP_IP_ADDRESS <> esp_ip_address
    # - ESP_ICON <> esp_icon
    # - OH_WEB_URL <> OH_WEB_URL
    # - ROW_REFERENCE  <> PAGE_ROW_INDEX + row_index
    
    # Save the template
    ${_JQ} ".[] | select(.label | contains(${ESP_PATTERN}))" ${tag}.json > ${tag}_ESP_8266_TEMPLATE.json
done
````

## Links

- MQTT Things and Channels Binding: https://www.openhab.org/addons/bindings/mqtt.generic/
- Python HowDoI: https://openhab-scripters.github.io/openhab-helper-libraries/Guides/But%20How%20Do%20I.html
- Actions: https://openhab-scripters.github.io/openhab-helper-libraries/Guides/Actions.html#actions
- Icon set names: https://community.openhab.org/t/names-of-the-default-icon-sets/22800/4
    ````commandline
    var iconsets = [
        { id: 'freepik-household', name: 'Builtin: Freepik Household', type: 'builtin', colorize: true },
        { id: 'freepik-gadgets', name: 'Builtin: Freepik Gadgets', type: 'builtin', colorize: true },
        { id: 'freepik-housethings', name: 'Builtin: Freepik House Things', type: 'builtin', colorize: true },
        { id: 'smarthome-set', name: 'Builtin: Smart Home Set', type: 'builtin', colorize: true },
        { id: 'eclipse-smarthome-classic', name: 'Eclipse SmartHome Classic', type: 'oh2', oh2iconset: 'classic', colorize: false }
    ];
    ````
  
## Error & Fix
- RRD corrupted file
  - Error log: `[ERROR] [d4j.internal.RRD4jPersistenceService] - Could not create rrd4j database file '/var/lib/openhab/persistence/rrd4j/[RRD file name].rrd': Invalid file header. File [/var/lib/openhab/persistence/rrd4j/[RRD file name].rrd] is not a RRD4J RRD file`
  - Fix: `grep 'Invalid file header' /var/log/openhab/openhab.log | awk -F"'" '{print $2}' | sort -u | xargs rm -f`
- Permission issue
  - Error log: `[ERROR] [d4j.internal.RRD4jPersistenceService] - Could not create rrd4j database file '/var/lib/openhab/persistence/rrd4j/[RRD file name].rrd': Read failed, file /var/lib/openhab/persistence/rrd4j/[RRD file name].rrd not mapped for I/O`
  - Fix: `openhabian-config -> 10 | Apply Improvements -> 14 | Fix Permissions`
  - _Tips_: ZRam can create this issue, thanks to uninstall and reboot your Py.
- 