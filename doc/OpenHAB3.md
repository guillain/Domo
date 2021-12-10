# OpenHab 3

1. [Installation](#installation)
2. [Configuration](#configuration)
    1. [Map transformation](#map-transformation)
    2. [OpenHAB UI](#openhab-ui)
    3. [MQTT Broker](#mqtt-broker)
3. [Templates](#templates)
    1. [Generate your templates](#generate-your-templates)
4. [Links](#links)

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
| ESP-8266-Sensors | 21_Friendroom             | Layout     | `generated/OpenHAB/web_pages/ESP_8266_Sensors/Page_21_Friendroom.yml` |
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
**WIP**: Summary and deep dive on the TEMPLATES usage & creation.

### Generate your templates

To easily prepare the TEMPLATES, you can export your current configuration, clean it and convert it to template.

Below an example that can be used to do it:

````commandline
ESP_PATTERN="My_pattern_to_grabe_one_thing"
for tag in "things" "items" "links" "rules"; do
    # Grabe the current conf
    _curl "GET" ${tag} > ${tag}.json
    
    # Add the key words to be replaced, cf. `generate.sh` fct `_sed`
    # - ESP_REFERENCE <> esp_reference
    # - ESP_NAME <> esp_name
    # - ESP_LOCATION <> esp_location
    # - ESP_IP_ADDRESS <> esp_ip_address
    # - ESP_ICON <> esp_icon
    # - OPENHAB_WEB_URL <> OH_WEB_URL
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