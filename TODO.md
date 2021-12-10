# ToDo

1. [Integration](#integration)
2. [Improvement](#improvement)
    1. [Automation](#automation)
    2. [Hardware](#hardware)
    3. [Security](#security)
    4. [MQTT](#mqtt)
3. [Legend](#legend)

## Integration

- &#10003; ESP-32 web-cam
- &#10004; ESP-8266 Sensors
- &#10003; ESP-8266 RFID
- &#10008; ESP-8266 Wifi repeater (for the ground + garage/garden)
- &#10008; ESP-8266 Intercom -> OH3 -> twilio -> SMS (notif) / call (v2 for dual voice com)
- &#10007; RGB lights
- &#10007; Matrix creator
- &#10007; Jarvis
- &#10007; iRobot

## Improvement

### Automation

- &#10008; OH3 Web pages generation
- &#10008; HABPanel Web pages generation
- &#10008; OpenHABian script for fast setup
- &#126; ESP factory

### Hardware

- &#10004; Node-Red -> OH3 Rules
- &#10003; Raspberry 3b+ -> 4b (2/4/8?)

### Security

- &#10008; Certificates (let's encrypt)
    - &#10008; Let's encrypt agent on the Py
    - &#10007; HTTPs AP backend
    - &#10008; HTTPs OH3
    - &#10008; HTTPs ESP
    - &#10007; MQTTs Mosquitto + ESP + OH3
- &#10007; Centralized user mgt system (to introduce OAuth2)

### MQTT

- &#10007; ESP-32-Cam, full migration
- &#10007; ESP-8266-RFID, collect system metrics

## Legend

- &#10007;: to do as lowest priority
- &#10008;: To do as next priority
- &#126; Ongoing
- &#10003;: Done
- &#10004;: Done with automation and/or factory