# Provisioning script

1. [Help](#help)
2. [Default parameters](#default-parameters)
3. [Templates](#templates)
   1. [Logic](#logic) 
   2. [Generate your templates](#generate-your-templates)
4. [Runs](#runs)
   1. [OpenHAB 3](#openhab-3)
   2. [HABPanel](#habpanel)

Locate in the root of the `app` folder, the script `generate.sh` allow you to:
- create, update or destroy OH3  configuration related to the _Things_ and _Items_ and their associated _Links_ and _Rules_
- create the static web pages required to populate the GUIs

## Help

`bash generate.sh -h`

````commandline
Used to provision OpenHAB3 via API with the help of JSON templates and to generate the template web files.
    -h | --help                           Print this help.
    -a | --action                         Which action to perform? Can be: create, update, destroy. Required.
    -c | --components                     On which component the action must be performed? Can be: all or one of things, items, links, rules. Required.
    -t | --ohtoken                        OpenHab token. Required.
    -s | --startindex                     Starting ESP index. Default: 15.
    -e | --endindex                       Ending ESP index. Default: 30.
    -i | --ippattern                      ESP IP pattern used like a prefix. Default: 10.1.1.1.
    -u | --ohurl                          OpenHab URL. Default: http://domo:8080.
    -w | --rowindex                       Starting row index to build the Overview pages. Default: 1.
    -p | --webpage <> -P | --nowebpage    Should I generate the OpenHab web pages?. Default: 0.
    -r | --runapi  <> -R | --norunapi     Should I run the API call? Default: 0.
    -d | --doitems <> -D | --nodoitems    Should I do all single items? Default: 1.
    -v | --verbose                        Display verbose traces. Default: 0
````

## Default parameters

Can be changed directly on the top of the `app/generate.sh` script file.

````commandline
EXEC_API=0
DO_ITEMS=1
WEB_PAGES=0
DEBUG=0

ESP_INDEX_START=15
ESP_INDEX_END=30
ESP_IP_PATTERN="10.1.1.1"

PAGE_ROW_INDEX=1

OH_WEB_URL="http://domo:8080"
OH_TOKEN=""

INPUT_DIR="./"
GENE_DIR="generate/"
API_DIR="${INPUT_DIR}OpenHAB/API/"
TMP_FILE="temp.json"
_JQ="jq"
````

## Templates

### Logic
**WIP**

### Generate your templates

To easily prepare the TEMPLATEs, you can export your current configuration, clean it and convert it to template.

Below an example that can be used to do it:

````commandline
ESP_PATTERN="My_pattern_to_grabe_one_thing"
for tag in "things" "items" "links" "rules"; do
    # Grabe the current conf
    _curl "GET" ${tag} > ${tag}.json
    
    # Add the key words to be replaced, cf. `app/generate.sh` fct `_sed`
    # - ESP_REFERENCE <> esp_reference
    # - ESP_NAME <> esp_name
    # - ESP_LOCATION <> esp_location
    # - ESP_IP_ADDRESS <> esp_ip_address
    # - ESP_ICON <> esp_icon
    # - OPENHAB_WEB_URL <> OH_WEB_URL
    # - ROW_REFERENCE  <> PAGE_ROW_INDEX + row_index
    # - AP_SSID <> 
    # - AP_BSSID <> 
    
    # Save the template
    ${_JQ} ".[] | select(.label | contains(${ESP_PATTERN}))" ${tag}.json > ${tag}_ESP_8266_TEMPLATE.json
done
````

## Runs
**WIP**

### OpenHAB 3
**WIP**

### HABPanel
**WIP**
