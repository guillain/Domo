#!/bin/bash
# @Author: Guillain
# @Date: 2021/12/07
# @Version: 2.0 - 2021/12/12

# DEFAULT PARAMETERS #########################################################################################
INPUT_DIR=$(dirname "${PWD}/${0}")
GENE_DIR="${PWD}/../generated/"
API_DIR="${GENE_DIR}OpenHAB/API/"
source "${INPUT_DIR}/settings.ini"
if [ -f "${INPUT_DIR}/.env" ]; then source "${INPUT_DIR}/.env"; fi

_help(){
    echo "Used to generate configuration files and to provision OpenHAB3 via API with the help of JSON templates.
    -h | --help                                       Print this help.
    -a | --action [create|provision|update|destroy]   Which action to perform? Can be: create, provision, update or destroy. Required.
    -c | --components [all|things|items|links|rules]  On which component the action must be performed? Can be: all or one of things, items, links, rules. Required.
    -t | --ohtoken [token]                            OpenHab token. Required.
    -u | --ohurl [http://url.com]                     OpenHab URL. Default: ${OH_WEB_URL}.
    -n | --name [ESP_NAME]                            Name of the ESP to collect. Required and used only by the action [create].
    -i | --ippattern [ESP_IP_PATTERN]                 ESP IP pattern used like a prefix. Default: ${ESP_IP_PATTERN}.
    -s | --startindex [ESP_INDEX_START]               Starting ESP index. Default: ${ESP_INDEX_START}.
    -e | --endindex [ESP_INDEX_END]                   Ending ESP index. Default: ${ESP_INDEX_END}.
    -w | --rowindex [PAGE_ROW_INDEX]                  Starting row index to build the Overview pages. Default: ${PAGE_ROW_INDEX}.
    -p | --convert <> -P | --noconvert                Should I convert the TEMPLATE?. Default: ${DO_CONVERT}.
    -f | --flush   <> -F | --noflush                  Clean the previous execution. Default: ${DO_FLUSH}.
    -r | --runapi  <> -R | --norunapi                 Should I run the API call? Default: ${EXEC_API}.
    -l | --dolinks <> -L | --nodolinks                Should I do all single items? Default: ${DO_LINKS}.
    -o | --output [folder]                            Output folder. Default: ${GENE_DIR}.
    -v | --verbose [0..4]                             Verbosity level traces. Default: ${DEBUG_LEVEL}."
}

# Map debug level ########################################################
# @Arg #1: level,    integer
##########################################################################
_map_debug(){
    case "${1}" in
        0)   echo "DEBUG";;
        1)   echo "INFO";;
        2)   echo "WARN";;
        3|4) echo "ERROR";;
        *)   echo "Debug level not found, exit"; exit 1;;
    esac
}

# Log message ############################################################
# @Arg #1: level,    integer,  0: debug, 1: info, 2: warning, 3: error, 4: error + help
# @Arg #2: layer,    integer,  nbr of prefix to add in the line
# @Arg #3: exit,     integer,  0: nothing, [1...]: exit
# @Arg #4: message,  string,   text to send
##########################################################################
_log(){
    echo -e "$(date +'%Y-%d-%m %T')\t$(_map_debug "${1}")\t${4}" >> test.log

    if [ "${1}" -ge "${DEBUG_LEVEL}" ]; then
        prefix="";
        if [ "${2}" -gt 0 ]; then prefix="  "; for i in $(seq 1 "${2}"); do prefix="----${prefix::-2}> "; done; fi
        if [ "${LOG_FILE}" != "" ]; then echo -e "$(date +'%Y-%d-%m %T')\t$(_map_debug "${1}")\t${4}" >> "${LOG_FILE}"; fi
        echo -e "${prefix}${4}"
        if [ "${1}" -eq 4 ]; then _help; fi
        if [ "${3}" -ge 1 ]; then echo "exit ${3}"; exit "${3}"; fi
    fi
}

# ARGUMENTS ##################################################################################################
TEMP=$(getopt -o ha:c:n:rRlLs:e:i:u:t:w:pPo:fFv: \
        --long help,action:,components:,name:,runapi,norunapi,dolinks,nodolinks,startindex:,endindex:,ippattern:,ohurl:,ohtoken:,rowindex:,convert,flush,noflush,output:,verbose: \
        -n 'provisioning.sh' -- "$@")
# shellcheck disable=SC2181
if [ $? != 0 ] ; then _log 4 0 1 "Wrong argument provided, thanks to read carefully the help :)"; fi
eval set -- "$TEMP"
while true; do
  case "${1}" in
    -h | --help )        _help;                  exit 0;;
    -a | --action )      ACTION="${2}";          shift 2;;
    -c | --components )  COMPONENTS="${2}";      shift 2;;
    -n | --name )        ESP_NAME="${2}";        shift 2;;
    -r | --runapi )      EXEC_API=1;             shift;;
    -R | --norunapi )    EXEC_API=0;             shift;;
    -l | --dolinks )     DO_LINKS=1;             shift;;
    -L | --nodolinks )   DO_LINKS=0;             shift;;
    -p | --convert )     DO_CONVERT=1;           shift;;
    -P | --noconvert )   DO_CONVERT=0;           shift;;
    -s | --startindex )  ESP_INDEX_START="${2}"; shift 2;;
    -e | --endindex )    ESP_INDEX_END="${2}";   shift 2;;
    -i | --ippattern )   ESP_IP_PATTERN="${2}";  shift 2;;
    -u | --ohurl )       OH_WEB_URL="${2}";      shift 2;;
    -t | --ohtoken )     OH_TOKEN="${2}";        shift 2;;
    -w | --rowindex )    PAGE_ROW_INDEX="${2}";  shift 2;;
    -v | --verbose )     DEBUG_LEVEL="${2}";     shift 2;;
    -o | --output )      GENE_DIR="${2}";        shift 2;;
    -f | --flush )       DO_FLUSH=1;             shift;;
    -F | --noflush )     DO_FLUSH=0;             shift;;
    -- )                 shift;                  break ;;
    * )                  break ;;
  esac
done

if [ "${ACTION}" == "" ];     then _log 4 0 1  "Action is missing."; fi
if [ "${ACTION}" == "create" ] && [ "${ESP_NAME}" == "" ]; then _log 4 1 1  "ESP name is missing when [create] is actioned."; fi
if [ "${COMPONENTS}" == "" ]; then _log 4 0 1  "Components is missing."; fi
if [ "${OH_TOKEN}" == "" ];   then _log 4 0 1  "OpenHAB token is missing."; fi
if [ "${DO_FLUSH}" -eq 1 ] && [ "${DO_CONVERT}" -eq 0 ]; then _log 4 0 1  "Can't perform action when flush and no conversion have been selected."; fi

# FUNCTIONS ##################################################################################################

# Convert from TEMPLATE to usable file ###################################
# @Arg #1: input file
# @Arg #2: output file
##########################################################################
_convert(){
    sed -e '/"state"/d' \
        -e "s/ESP_REFERENCE/${esp_reference}/g" \
        -e "s/ESP_NAME/${esp_name}/g" \
        -e "s/ESP_ICON/${esp_icon}/g" \
        -e "s/ESP_PASSWORD/${ESP_PASSWORD}/g" \
        -e "s/ESP_LOCATION/${esp_location}/g" \
        -e "s/ESP_IP_ADDRESS/${esp_ip_address}/g" \
        -e "s/ESP_IP_PATTERN/${ESP_IP_PATTERN}/g" \
        -e "s/ESP_IP_SUBNET/${ESP_IP_SUBNET}/g" \
        -e "s/ESP_MQTT_USER/${ESP_MQTT_USER}/g" \
        -e "s/ESP_MQTT_PASSWORD/${ESP_MQTT_PASSWORD}/g" \
        \
        -e "s/AP_SSID_PASSWORD/${AP_SSID_PASSWORD}/g" \
        -e "s/AP_SSID/${AP_SSID}/g" \
        -e "s/AP_BSSID/${AP_BSSID}/g" \
        -e "s/AP_IP_ADDRESS/${AP_IP_ADDRESS}/g" \
        -e "s/AP_IP_SUBNET/${AP_IP_SUBNET}/g" \
        \
        -e "s/OH_WEB_URL/$(echo "${OH_WEB_URL}"  | sed 's/\//\\\//g')/g" \
        -e "s/ROW_REFERENCE/$((PAGE_ROW_INDEX + row_index))/g" \
        "${1}" > "${2}"
}

# Set ESP field values ###################################################
# @Arg #1: ESP reference (ESP_REFERENCE)
##########################################################################
_esp(){
    case ${1} in
        14) esp_model="ESP_8266_RFID";     esp_location="Entry";      esp_icon="oh:frontdoor";;
        15) esp_model="ESP_8266_Sensors";  esp_location="Entry";      esp_icon="oh:frontdoor";;
        16) esp_model="ESP_8266_Sensors";  esp_location="Livingroom"; esp_icon="oh:groundfloor";;
        17) esp_model="ESP_8266_Sensors";  esp_location="Kitchen";    esp_icon="oh:kitchen";;
        18) esp_model="ESP_8266_Sensors";  esp_location="Bathroom";   esp_icon="oh:bath";;
        19) esp_model="ESP_8266_Sensors";  esp_location="Nina";       esp_icon="oh:bedroom_orange";;
        20) esp_model="ESP_8266_Sensors";  esp_location="Luca";       esp_icon="oh:bedroom_blue";;
        21) esp_model="ESP_8266_Sensors";  esp_location="Guestroom";  esp_icon="oh:bedroom_red";;
        22) esp_model="ESP_8266_Sensors";  esp_location="Guillain";   esp_icon="oh:bedroom";;
        23) esp_model="ESP_8266_Sensors";  esp_location="DeskRoom";   esp_icon="oh:office";;
        24) esp_model="ESP_8266_Sensors";  esp_location="Garage";     esp_icon="oh:garage";;
        25) esp_model="ESP_8266_Sensors";  esp_location="Garden";     esp_icon="oh:garden";;
        26) esp_model="ESP_32_Cam";        esp_location="Entry";      esp_icon="oh:frontdoor";;
        27) esp_model="ESP_32_Cam";        esp_location="Garage";     esp_icon="oh:garage";;
        28) esp_model="ESP_32_Cam";        esp_location="Garden";     esp_icon="oh:garden";;
        29) esp_model="ESP_32_Cam";        esp_location="Lab";        esp_icon="oh:zoom";;
        30) esp_model="ESP_8266_Sensors";  esp_location="Lab";        esp_icon="oh:zoom";;
        98) esp_model="ESP_32_Cam";        esp_location="Lab32";        esp_icon="oh:zoom";;
        99) esp_model="ESP_8266_Sensors";  esp_location="Lab8266";        esp_icon="oh:zoom";;
        *)  _log 4 0 1 "ESP ref '${1}' does not exist";;
    esac
    esp_reference="${1}"
    esp_name="${esp_reference}_${esp_location}"
    esp_ip_address="${ESP_IP_PATTERN}${esp_reference}"
}

# JSON field value extraction ############################################
# @Arg #1: item name to grab
# @Arg #2: input JSON file
##########################################################################
_json_val(){
    jq ".${1}" "${2}" | sed 's/"//g'
}

# Convert from TEMPLATEs to usable pages #################################
# No @Arg, all come from global variables
##########################################################################
_std_tpl(){
    _log 1 0 0 "Standard files generation"

    _log 1 1 0 "Generate each single ESP file"
    for input_file in $(find . -type f | grep '_TEMPLATE' | grep -v API); do
        _log 1 2 0 "Tpl file: ${input_file}"
        row_index=0

        for esp_index in $(seq "${ESP_INDEX_START}" "${ESP_INDEX_END}"); do
            _esp "${esp_index}"
            if [ "$(echo "${input_file}" | grep -c "${esp_model}")" -ne 0 ]; then
                output_file="${input_file//_TEMPLATE/_${esp_name}}"
                _log 1 3 0 "ESP: ${esp_index}, row_index: ${row_index}, output_file: ${output_file}"
                
                _convert "${input_file}" "${output_file}"

                row_index=$((row_index+1))
            fi
        done
    done

    _log 1 1 0 "Merge the files"
    for input_header in $(find . -type f | grep "_HEADER" | grep -v API); do
        output_file="${input_header//_HEADER/}"
        filename_prefix="$(basename "${output_file}" | awk -F'.' '{print $1}')_"
        output_dir="$(dirname "${output_file}")"
        _log 1 2 0 "Header tpl: ${input_header}, filename_prefix: ${filename_prefix} output: ${output_file-}"

        _convert "${input_header}" "${output_file}"
        for input_tpl in $(find "${output_dir}" -type f | grep "${filename_prefix}" | grep -ve "_HEADER|_TEMPLATE"); do
            _log 1 3 0 "File: ${input_tpl}"
            
            cat "${input_tpl}" >> "${output_file}"
        done
    done
}

# API call request #######################################################
# @Arg #1: API verb
# @Arg #2: API URI without the `rest` word in the path and without the first slash
# @Arg #3: input data file, optional
##########################################################################
_api_request(){
    _log 1 3 0 "${1} ${2}"
    if [ "${3}" != "" ] && [ "${1}" != "DELETE" ]; then
        _log 0 4 0 "Request: curl -X ${1} ${OH_WEB_URL}/rest/${2} -u \"\${OH_TOKEN}:\" -H  \"accept: */*\"  -H \"Content-Type: application/json\" --data @${3}"
        _log 0 4 0 "Data file: ${3}"
        if [ ${EXEC_API} -eq 1 ]; then
            resp=$(curl -s -X "${1}" "${OH_WEB_URL}/rest/${2}" -u "${OH_TOKEN}:" -H  "accept: */*"  -H "Content-Type: application/json" --data @"${3}" 2>&1)
        fi
    else
        _log 0 4 0 "Request: curl -X ${1} ${OH_WEB_URL}/rest/${2} -u \"\${OH_TOKEN}:\" -H  \"accept: */*\"  -H \"Content-Type: application/json\""
        if [ ${EXEC_API} -eq 1 ]; then
            resp=$(curl -s -X "${1}" "${OH_WEB_URL}/rest/${2}" -u "${OH_TOKEN}:" -H  "accept: */*"  -H "Content-Type: application/json" 2>&1)
        fi
    fi
    _log 0 4 0 "Response: ${resp}"

    if [ "$(echo "${resp}" | grep '"error')" != "" ]; then
        _log 3 4 0 "ERROR: $(echo "${resp}" | awk -F'{' '{print $3}' | awk -F'}' '{print $1}')"
    fi
}

# Iteration over a JSON list for the API request #########################
# @Arg #1: API verb
# @Arg #2: input file
##########################################################################
_api_provision_tpl(){
    do_loop=${DO_LINKS}
    i_loop=0
    while [ ${do_loop} -eq 1 ]; do
        item_file="${2//.json/_${i_loop}.json}"
        jq ".[${i_loop}]" "${2}" > "${item_file}"
        if [ "$(wc -l < "${item_file}")" -le 3 ]; then
            rm "${item_file}"
            do_loop=0
        else
            case ${api_tag} in
                "things") if [ "${1}" != "POST" ]; then uri=$(_json_val "UID"      "${item_file}"); fi;;
                "items")                                uri=$(_json_val "name"     "${item_file}");;
                "links")                                uri=$(_json_val "itemName" "${item_file}")/$(_json_val "channelUID" "${item_file}");;
                "rules")  if [ "${1}" != "POST" ]; then uri=$(_json_val "uid"      "${item_file}"); fi;;
                *) _log 4 1 1 "API tag '${api_tag}' does not exist";;
            esac
            _api_request "${1}" "${api_tag}/${uri}" "${item_file}"
            i_loop=$((i_loop+1)) 
        fi
    done
}

# Iteration over a JSON list for the API request #########################
# @Arg #1: API tag
# @Arg #2: ESP name already provisioned to used as example to create the template
# @Arg #3: input JSON file
_api_create_tpl(){
    tpl_dir=$(dirname "${3}")
    _api_request "GET" "${1}" > "${1}.json" \
        && jq ".[] | select(.label | contains('${2}'))" "${1}.json" > "${tpl_dir}/${1}_TEMPLATE.json" \
        && rm "${1}.json"
}

# MAIN #######################################################################################################

# Prepare the environment
_log 1 0 0 "Environment setup"
if [ "${DO_FLUSH}" -eq 1 ] && [ -d "${GENE_DIR}" ]; then rm -r "${GENE_DIR}"; fi
cp -fr "${INPUT_DIR}" "${GENE_DIR}" && cd "${GENE_DIR}" || exit

# Generate the pages from the templates
if [ "${DO_CONVERT}" -eq 1 ]; then _std_tpl; fi

# Change done by API with the help of the template
_log 1 0 0 "API ${ACTION}"
api_tags="${COMPONENTS}"
if [ "${COMPONENTS}" == "all" ]; then 
    case ${ACTION} in
        "create"|"provision"|"update") api_tags="things items links rules";;
        "destroy") api_tags="rules links items things";;        
        *) _log 4 1 1 "Action '${ACTION}' does not exist";;
    esac
fi
_convert "OpenHAB/API/items_TEMPLATE.json" "OpenHAB/API/items.json" && rm "OpenHAB/API/items_TEMPLATE.json"

for api_tag in ${api_tags}; do
    _log 1 1 0 "Component: ${api_tag}"

    for esp_index in $(seq "${ESP_INDEX_START}" "${ESP_INDEX_END}"); do
        _esp "${esp_index}"
        input_template="${API_DIR}${esp_model}/${api_tag}_TEMPLATE.json"
        output_file="${API_DIR}${esp_model}/${api_tag}_${esp_name}.json"
        _log 1 2 0 "ESP: ${esp_name}, model: ${esp_model}, output_file: ${output_file}"

        if [ "${DO_CONVERT}" -eq 1 ]; then _convert "${input_template}" "${output_file}"; fi
        if [ ! -f "${output_file}" ]; then _log 2 3 1 "File doesn't exist. Thanks to run at least one time the converter before to request the API"; fi

        case ${ACTION} in
            "create")         _api_create_tpl    "${api_tag}" "${esp_name}"    "${output_file}";;
            "provision")
                case ${api_tag} in
                    "things") _api_provision_tpl "POST"       "${output_file}";;
                    "items")  _api_request       "PUT"        "${api_tag}"     "${output_file}";;
                    "links")  _api_provision_tpl "PUT"        "${output_file}";;
                    "rules")  _api_provision_tpl "POST"       "${output_file}";;
                    *) _log 4 0 1 "API tag '${api_tag}' does not exist.";;
                esac
                ;;
            "update")
                case ${api_tag} in
                    "things") _api_provision_tpl "PUT"        "${output_file}";;
                    "items")  _api_request       "PUT"        "${api_tag}"     "${output_file}";;
                    "links")  _api_provision_tpl "PUT"        "${output_file}";;
                    "rules")  _api_provision_tpl "PUT"        "${output_file}";;
                    *) _log 4 0 1 "API tag '${api_tag}' does not exist";;
                esac
                ;;
            "destroy") _api_provision_tpl "DELETE" "${output_file}";;
            *) _log 4 0 1 "Action '${ACTION}' does not exist";;
        esac
    done
done

_log 1 0 0 "Done"
exit 0
