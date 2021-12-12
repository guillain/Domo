# Provisioning script

1. [PreRequisites](#prerequisites)
2. [Parameters](#parameters)
   1. [Arguments](#arguments)
   2. [Default](#default)
   3. [Critical](#critical)
3. [Templates](#templates)
   1. [Logic](#logic)
   2. [Generate your templates](#generate-your-templates)
4. [Runs](#runs)
   1. [OpenHAB 3](#openhab-3)
   2. [HABPanel](#habpanel)
5. [Traces](#traces)

Locate in the root of the `app` folder, the script `provisioning.sh` allow you to:
- create, update or destroy OH3  configuration related to the _Things_ and _Items_ and their associated _Links_ and _Rules_
- create the static web pages required to populate the GUIs

## PreRequisites
- Bash shell + `jq`
- Network access to OpenHAB3
- Fulfil the `settings.ini` file

## Parameters

### Arguments
`bash provisioning.sh -h`

````commandline
Used to generate configuration files and to provision OpenHAB3 via API with the help of JSON templates.
    -h | --help                                       Print this help.
    -a | --action [create|provision|update|destroy]   Which action to perform? Can be: create, provision, update or destroy. Required.
    -c | --components [all|things|items|links|rules]  On which component the action must be performed? Can be: all or one of things, items, links, rules. Required.
    -t | --ohtoken [token]                            OpenHab token. Required.
    -u | --ohurl [http://url.com]                     OpenHab URL. Default: http://domo:8080.
    -n | --name [ESP_NAME]                            Name of the ESP to collect. Required and used only by the action [create].
    -i | --ippattern [ESP_IP_PATTERN]                 ESP IP pattern used like a prefix. Default: 10.1.1.1.
    -s | --startindex [ESP_INDEX_START]               Starting ESP index. Default: 15.
    -e | --endindex [ESP_INDEX_END]                   Ending ESP index. Default: 30.
    -w | --rowindex [PAGE_ROW_INDEX]                  Starting row index to build the Overview pages. Default: 1.
    -p | --convert <> -P | --noconvert                Should I convert the TEMPLATE?. Default: 0.
    -f | --flush   <> -F | --noflush                  Clean the previous execution. Default: ${DO_FLUSH}.
    -r | --runapi  <> -R | --norunapi                 Should I run the API call? Default: 0.
    -l | --dolinks <> -L | --nodolinks                Should I do all single items? Default: 1.
    -o | --output [folder]                            Output folder. Default: /d/documents/Domo/Domo/app/../generated/.
    -v | --verbose [0..4]                             Verbosity level traces. Default: 1.
````

### Default
They are provided by the file `settings.ini`.

````commandline
#!/bin/bash
DEBUG_LEVEL=1                   # 0: debug, 1: info, 2: warning, 3: error, 4: error + help
LOG_FILE=trace.log              # if no file provided, no log reported :)

EXEC_API=0                      # [0,1] execute or not the API request
DO_LINKS=1                      # [0,1] execute or not the links creation
DO_CONVERT=0                    # [0,1] create the file template or not, if not use the existing for the other processes
DO_FLUSH=1                      # [0,1] Clean the previous execution by deleting the generated folder
PAGE_ROW_INDEX=1                # [0,1] Web page starting row index
ESP_INDEX_START=15              # [\d] ESP starting index 
ESP_INDEX_END=30                # [\d] ESP ending index

OH_WEB_URL=http://domo:8080     # OH3 we url
OH_TOKEN=                       # OH3 web token

ESP_USERNAME=administrator      # ESP username for web login
ESP_PASSWORD=                   # ESP password of the previous user

ESP_IP_PATTERN=10.1.1.1         # ESP IP pattern as starting point, ESP_REFERENCE will be as the last 2 digits
ESP_IP_SUBNET=255.255.255.0     # ESP IP subnet

ESP_MQTT_USER=MosquittoOpenHAB  # ESP username set for OH3 for MQTT login
ESP_MQTT_USER=MosquittoESP      # ESP MQTT user set for the ESP
ESP_MQTT_PASSWORD=              # ESP MQTT password of the previous user

AP_IP_ADDRESS=192.168.4.1       # IP address of the AP
AP_IP_SUBNET=255.255.255.0      # Subnet of the AP

AP_SSID=Domo                    # SSID of the AP
AP_SSID_PASSWORD=               # Password of the previous SSID
AP_BSSID=                       # BSSID of the AP
````

### Critical
The script can load an `.env` file if it's existing.

So don't hesitate to put your token and password into instead to have that in the `settings.ini` file.

For that you can duplicate and rename the file from`sample.env` to `.env` and add your credentials into.

## Models
| esp_reference   | esp_model        | esp_location | esp_icon          |
|-----------------|------------------|--------------|-------------------|
| 14              | ESP_8266_RFID    | Entry        | oh:frontdoor      |
| 15              | ESP_8266_Sensors | Entry        | oh:frontdoor      |
| 16              | ESP_8266_Sensors | Livingroom   | oh:groundfloor    |
| 17              | ESP_8266_Sensors | Kitchen      | oh:kitchen        |
| 18              | ESP_8266_Sensors | Bathroom     | oh:bath           |
| 19              | ESP_8266_Sensors | Nina         | oh:bedroom_orange |
| 20              | ESP_8266_Sensors | Luca         | oh:bedroom_blue   |
| 21              | ESP_8266_Sensors | Guestroom    | oh:bedroom_red    |
| 22              | ESP_8266_Sensors | Guillain     | oh:bedroom        |
| 23              | ESP_8266_Sensors | DeskRoom     | oh:office         |
| 24              | ESP_8266_Sensors | Garage       | oh:garage         |
| 25              | ESP_8266_Sensors | Garden       | oh:garden         |
| 26              | ESP_32_Cam       | Entry        | oh:frontdoor      |
| 27              | ESP_32_Cam       | Garage       | oh:garage         |
| 28              | ESP_32_Cam       | Garden       | oh:garden         |
| 29              | ESP_32_Cam       | Lab          | oh:zoom           |
| 30              | ESP_8266_Sensors | Lab          | oh:zoom           |
| 98              | ESP_32_Cam       | Lab          | oh:zoom           |
| 99              | ESP_8266_Sensors | Lab          | oh:zoom           |

- esp_name="${esp_reference}_${esp_location}"
- esp_ip_address="${ESP_IP_PATTERN}${esp_reference}"

## Templates

### Logic
- Each file named with `_TEMPLATE` or `_HEADER` will be converted to a usable file with the help of the defined 
variables and constants. 
- If a file named with `_HEADER` is found, it's used to create the header of a new file and concatenate the other 
files named with `_TEMPLATE` info.
- A loop over the ESP reference range is done and a mapping is made to identify which component must be deployed. 


- Example:
  - Insights
    - Arguments:
      - ESP_INDEX_START: 1
      - ESP_INDEX_END: 3
      - ESP_IP_PATTERN: 10.1.1.10
      - Models:
        - 1
           1) esp_model="ESP_8266_RFID"
           2) esp_location="Entry"
           3) esp_icon="oh:frontdoor"
        - 2 
           1) esp_model="ESP_8266_Sensors"
           2) esp_location="Entry"
           3) esp_icon="oh:frontdoor"
        - 3 
           1) esp_model="ESP_32_Cam"
           2) esp_location="Livingroom"
           3) esp_icon="oh:groundfloor"
    - Input files:
      - page_HEADER.html
        > hello
      - page_TEMPLATE.html
        > it's my IP address: ESP_IP_ADDRESS
  - Generated files
    - ESP_8266_RFID/page_1_Entry.html
      > it's my IP address: 10.1.1.101
    - ESP_8266_RFID/page_2_Entry.html
      > it's my IP address: 10.1.1.102
    - ESP_8266_RFID/page_3_Entry.html
      > it's my IP address: 10.1.1.103
    - ESP_8266_RFID/page.html
      > hello
      
      > it's my IP address: 10.1.1.101
      
      > it's my IP address: 10.1.1.102
      
      > it's my IP address: 10.1.1.103

### Generate your templates

To easily prepare the TEMPLATEs, you can export your current configuration, clean it and convert it to template.

This is done with the help of the action `create` of the `provisioning.sh` script.

## Runs
- Create the templates: `$ ./provisioning.sh -c all -a create -n 14_Entry`
- Masse provisioning: `$ ./provisioning.sh -c all -a provision`
- Masse update: `$ ./provisioning.sh -c all -a update`
- Masse destroy: `$ ./provisioning.sh -c all -a destroy`

### OpenHAB 3
Cf. [the setup of the OpenHAB3 web pages](OpenHAB3.md#openhab-ui)

### HABPanel
Cf. [the setup of the HABPanel web pages](HABPanel.md#layout)

## Traces

### Provision
`./provisioning.sh -prl -a provision -c things -p -s98 -e99`
````commandline
Environment setup
Standard files generation
----> Generate each single ESP file
--------> Tpl file: ./ESP/ESP_32_Cam/myconfig_TEMPLATE.h
------------> ESP: 98, row_index: 0, output_file: ./ESP/ESP_32_Cam/myconfig_98_Lab32.h
--------> Tpl file: ./ESP/ESP_8266_RFID/settings_TEMPLATE.json
--------> Tpl file: ./ESP/ESP_8266_Sensors/Custom_TEMPLATE.h
------------> ESP: 99, row_index: 0, output_file: ./ESP/ESP_8266_Sensors/Custom_99_Lab8266.h
--------> Tpl file: ./HABPanel/web_pages/Camera_TEMPLATE.html
--------> Tpl file: ./HABPanel/web_pages/RFID_TEMPLATE.html
--------> Tpl file: ./HABPanel/web_pages/Sensors_TEMPLATE.html
--------> Tpl file: ./HABPanel/web_pages/Streaming_TEMPLATE.html
--------> Tpl file: ./HABPanel/web_pages/test_TEMPLATE.html
--------> Tpl file: ./NodeRed/ESP_32_Cam/settings_TEMPLATE.json
------------> ESP: 98, row_index: 0, output_file: ./NodeRed/ESP_32_Cam/settings_98_Lab32.json
--------> Tpl file: ./NodeRed/ESP_8266_RFID/settings_TEMPLATE.json
--------> Tpl file: ./NodeRed/ESP_8266_Sensors/settings_TEMPLATE.json
------------> ESP: 99, row_index: 0, output_file: ./NodeRed/ESP_8266_Sensors/settings_99_Lab8266.json
--------> Tpl file: ./OpenHAB/web_pages/ESP_32_Cam/overview_TEMPLATE.yml
------------> ESP: 98, row_index: 0, output_file: ./OpenHAB/web_pages/ESP_32_Cam/overview_98_Lab32.yml
--------> Tpl file: ./OpenHAB/web_pages/ESP_32_Cam/page_TEMPLATE.yml
------------> ESP: 98, row_index: 0, output_file: ./OpenHAB/web_pages/ESP_32_Cam/page_98_Lab32.yml
--------> Tpl file: ./OpenHAB/web_pages/ESP_8266_RFID/overview_TEMPLATE.yml
--------> Tpl file: ./OpenHAB/web_pages/ESP_8266_RFID/page_TEMPLATE.yml
--------> Tpl file: ./OpenHAB/web_pages/ESP_8266_Sensors/overview_TEMPLATE.yml
------------> ESP: 99, row_index: 0, output_file: ./OpenHAB/web_pages/ESP_8266_Sensors/overview_99_Lab8266.yml
--------> Tpl file: ./OpenHAB/web_pages/ESP_8266_Sensors/page_TEMPLATE.yml
------------> ESP: 99, row_index: 0, output_file: ./OpenHAB/web_pages/ESP_8266_Sensors/page_99_Lab8266.yml
----> Merge the files
--------> Header tpl: ./OpenHAB/web_pages/ESP_32_Cam/overview_HEADER.yml, filename_prefix: overview_ output: ./OpenHAB/web_pages/ESP_32_Cam/overview.yml
------------> File: ./OpenHAB/web_pages/ESP_32_Cam/overview_98_Lab32.yml
------------> File: ./OpenHAB/web_pages/ESP_32_Cam/overview_HEADER.yml
------------> File: ./OpenHAB/web_pages/ESP_32_Cam/overview_TEMPLATE.yml
--------> Header tpl: ./OpenHAB/web_pages/ESP_8266_RFID/overview_HEADER.yml, filename_prefix: overview_ output: ./OpenHAB/web_pages/ESP_8266_RFID/overview.yml
------------> File: ./OpenHAB/web_pages/ESP_8266_RFID/overview_HEADER.yml
------------> File: ./OpenHAB/web_pages/ESP_8266_RFID/overview_TEMPLATE.yml
--------> Header tpl: ./OpenHAB/web_pages/ESP_8266_Sensors/overview_HEADER.yml, filename_prefix: overview_ output: ./OpenHAB/web_pages/ESP_8266_Sensors/overview.yml
------------> File: ./OpenHAB/web_pages/ESP_8266_Sensors/overview_99_Lab8266.yml
------------> File: ./OpenHAB/web_pages/ESP_8266_Sensors/overview_HEADER.yml
------------> File: ./OpenHAB/web_pages/ESP_8266_Sensors/overview_TEMPLATE.yml
API provision
----> Component: things
--------> ESP: 98_Lab32, model: ESP_32_Cam, output_file: /d/documents/Domo/Domo/app/../generated/OpenHAB/API/ESP_32_Cam/things_98_Lab32.json
------------> POST things/
--------> ESP: 99_Lab8266, model: ESP_8266_Sensors, output_file: /d/documents/Domo/Domo/app/../generated/OpenHAB/API/ESP_8266_Sensors/things_99_Lab8266.json
------------> POST things/
Done
````

### Update
`./provisioning.sh -PrlF -a update -c things -s98 -e99`
````commandline
Environment setup
API update
----> Component: things
--------> ESP: 98_Lab32, model: ESP_32_Cam, output_file: /d/documents/Domo/Domo/app/../generated/OpenHAB/API/ESP_32_Cam/things_98_Lab32.json
------------> PUT things/http:url:98_Lab32
--------> ESP: 99_Lab8266, model: ESP_8266_Sensors, output_file: /d/documents/Domo/Domo/app/../generated/OpenHAB/API/ESP_8266_Sensors/things_99_Lab8266.json
------------> PUT things/mqtt:topic:Domo:99_Lab8266
Done
````
### Destroy
`./provisioning.sh -PrlF -a destroy -c things -s98 -e99`
````commandline
Environment setup
API destroy
----> Component: things
--------> ESP: 98_Lab32, model: ESP_32_Cam, output_file: /d/documents/Domo/Domo/app/../generated/OpenHAB/API/ESP_32_Cam/things_98_Lab32.json
------------> DELETE things/http:url:98_Lab32
--------> ESP: 99_Lab8266, model: ESP_8266_Sensors, output_file: /d/documents/Domo/Domo/app/../generated/OpenHAB/API/ESP_8266_Sensors/things_99_Lab8266.json
------------> DELETE things/mqtt:topic:Domo:99_Lab8266
Done
````
