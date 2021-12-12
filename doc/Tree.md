## Tree

````commandline
$ find . | grep -v '.git' | grep -v '.idea' | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"
.
  |-.env
  |-app
  |  |-.env
  |  |-ESP
  |  |  |-ESP_32_Cam
  |  |  |  |-myconfig_TEMPLATE.h
  |  |  |  |-platformio.ini
  |  |  |-ESP_8266_RFID
  |  |  |  |-platformio.ini
  |  |  |  |-settings_TEMPLATE.json
  |  |  |  |-users.json
  |  |  |-ESP_8266_Sensors
  |  |  |  |-config.dat
  |  |  |  |-Custom_TEMPLATE.h
  |  |  |  |-lib
  |  |  |  |  |-_P028_BME280.ino
  |  |  |  |  |-_P045_MPU6050.ino
  |  |  |  |  |-_P111_RC522_RFID.ino
  |  |  |  |-platformio.ini
  |  |  |  |-rules1.txt
  |  |  |  |-rules2.txt
  |  |  |  |-rules4.txt
  |  |-HABPanel
  |  |  |-images
  |  |  |  |-first_floor.png
  |  |  |  |-ground.png
  |  |  |  |-outdoor.png
  |  |  |  |-second_floor.png
  |  |  |-web_pages
  |  |  |  |-Camera_TEMPLATE.html
  |  |  |  |-first_floor.html
  |  |  |  |-ground_floor.html
  |  |  |  |-outdoor.html
  |  |  |  |-RFID_TEMPLATE.html
  |  |  |  |-second_floor.html
  |  |  |  |-Sensors_TEMPLATE.html
  |  |  |  |-Streaming_TEMPLATE.html
  |  |  |  |-test_TEMPLATE.html
  |  |-NodeRed
  |  |  |-ESP_32_Cam
  |  |  |  |-functions.json
  |  |  |  |-settings_TEMPLATE.json
  |  |  |-ESP_8266_RFID
  |  |  |  |-functions.json
  |  |  |  |-settings_TEMPLATE.json
  |  |  |-ESP_8266_Sensors
  |  |  |  |-functions.json
  |  |  |  |-settings_TEMPLATE.json
  |  |-OpenHAB
  |  |  |-API
  |  |  |  |-ESP_32_Cam
  |  |  |  |  |-items_TEMPLATE.json
  |  |  |  |  |-links_TEMPLATE.json
  |  |  |  |  |-rules_TEMPLATE.json
  |  |  |  |  |-things_TEMPLATE.json
  |  |  |  |-ESP_8266_RFID
  |  |  |  |  |-items_TEMPLATE.json
  |  |  |  |  |-links_TEMPLATE.json
  |  |  |  |  |-rules_TEMPLATE.json
  |  |  |  |  |-things_TEMPLATE.json
  |  |  |  |-ESP_8266_Sensors
  |  |  |  |  |-items_TEMPLATE.json
  |  |  |  |  |-links_TEMPLATE.json
  |  |  |  |  |-rules_TEMPLATE.json
  |  |  |  |  |-things_TEMPLATE.json
  |  |  |  |-items_TEMPLATE.json
  |  |  |-map
  |  |  |  |-lamp.map
  |  |  |  |-switch.map
  |  |  |-web_pages
  |  |  |  |-ESP_32_Cam
  |  |  |  |  |-overview_HEADER.yml
  |  |  |  |  |-overview_TEMPLATE.yml
  |  |  |  |  |-page_TEMPLATE.yml
  |  |  |  |-ESP_8266_RFID
  |  |  |  |  |-overview_HEADER.yml
  |  |  |  |  |-overview_TEMPLATE.yml
  |  |  |  |  |-page_TEMPLATE.yml
  |  |  |  |-ESP_8266_Sensors
  |  |  |  |  |-overview_HEADER.yml
  |  |  |  |  |-overview_TEMPLATE.yml
  |  |  |  |  |-page_TEMPLATE.yml
  |  |-provisioning.sh
  |  |-runs.log
  |  |-settings.ini
  |  |-test.log
  |  |-trace.log
  |-doc
  |  |-ESP.md
  |  |-ESP_32_Cam.md
  |  |-ESP_8266_RFID.md
  |  |-ESP_8266_Sensors.md
  |  |-HABPanel.md
  |  |-images
  |  |  |-ESP_32_Cam-Hardware.jpg
  |  |  |-ESP_32_Cam-Overview.png
  |  |  |-ESP_32_Cam-Pinout.png
  |  |  |-ESP_32_Cam.png
  |  |  |-ESP_8266-D1_mini-Pinout.png
  |  |  |-ESP_8266-D1_mini.png
  |  |  |-ESP_8266-D1_mini_RFID-Pined.png
  |  |  |-ESP_8266_RFID-Hardware.jpg
  |  |  |-ESP_8266_RFID-Overview.png
  |  |  |-ESP_8266_Sensors-Device_overview.png
  |  |  |-ESP_8266_Sensors-Hardware.jpg
  |  |  |-ESP_8266_Sensors-Overview.png
  |  |  |-HABPanel-Camera.png
  |  |  |-HABPanel-Door.png
  |  |  |-HABPanel-Overview.png
  |  |  |-HABPanel-Sensors.png
  |  |  |-HABPanel-Streaming.png
  |  |  |-HABPanel_first_floor.png
  |  |  |-HABPanel_ground.png
  |  |  |-HABPanel_outdoor.png
  |  |  |-HABPanel_second_floor.png
  |  |  |-Infrastructure-Network.png
  |  |  |-Infrastructure-Overview.png
  |  |  |-iRobot.jpg
  |  |  |-Jarvis.jpg
  |  |  |-Matrix_creator.jpg
  |  |  |-OH3-ESP_32_Cam-Overview.png
  |  |  |-OH3-ESP_32_Cam-Page.png
  |  |  |-OH3-ESP_8266_RFID-Page.png
  |  |  |-OH3-ESP_8266_Sensors-Overview.png
  |  |  |-OH3-ESP_8266_Sensors-Page.png
  |  |  |-OH3-LogViewer.png
  |  |  |-OH3-Overview-Location.png
  |  |  |-OH3-Properties.png
  |  |  |-OH3-Welcome.png
  |  |  |-OH3_Temperature-analyse.png
  |  |  |-RaspAP-Dashboard.png
  |  |  |-Raspberry_3Bplus.jpg
  |  |  |-Raspberry_4Bplus-Wifi.jpg
  |  |  |-Raspberry_4Bplus.jpg
  |  |  |-RFID_RC522-Board.png
  |  |  |-RFID_RC522-Overview.png
  |  |  |-RFID_RC522-Pinout.png
  |  |-Infrastructure.md
  |  |-Integration_matrix.md
  |  |-Links.md
  |  |-Naming_convention.md
  |  |-Network.md
  |  |-OpenHAB3.md
  |  |-OpenHABian.md
  |  |-Provisioning_script.md
  |  |-RaspAP.md
  |  |-Tree.md
  |-generated
  |  |-.env
  |  |-ESP
  |  |  |-ESP_32_Cam
  |  |  |  |-myconfig_98_Lab32.h
  |  |  |  |-myconfig_TEMPLATE.h
  |  |  |  |-platformio.ini
  |  |  |-ESP_8266_RFID
  |  |  |  |-platformio.ini
  |  |  |  |-settings_TEMPLATE.json
  |  |  |  |-users.json
  |  |  |-ESP_8266_Sensors
  |  |  |  |-config.dat
  |  |  |  |-Custom_99_Lab8266.h
  |  |  |  |-Custom_TEMPLATE.h
  |  |  |  |-lib
  |  |  |  |  |-_P028_BME280.ino
  |  |  |  |  |-_P045_MPU6050.ino
  |  |  |  |  |-_P111_RC522_RFID.ino
  |  |  |  |-platformio.ini
  |  |  |  |-rules1.txt
  |  |  |  |-rules2.txt
  |  |  |  |-rules4.txt
  |  |-HABPanel
  |  |  |-images
  |  |  |  |-first_floor.png
  |  |  |  |-ground.png
  |  |  |  |-outdoor.png
  |  |  |  |-second_floor.png
  |  |  |-web_pages
  |  |  |  |-Camera_TEMPLATE.html
  |  |  |  |-first_floor.html
  |  |  |  |-ground_floor.html
  |  |  |  |-outdoor.html
  |  |  |  |-RFID_TEMPLATE.html
  |  |  |  |-second_floor.html
  |  |  |  |-Sensors_TEMPLATE.html
  |  |  |  |-Streaming_TEMPLATE.html
  |  |  |  |-test_TEMPLATE.html
  |  |-NodeRed
  |  |  |-ESP_32_Cam
  |  |  |  |-functions.json
  |  |  |  |-settings_98_Lab32.json
  |  |  |  |-settings_TEMPLATE.json
  |  |  |-ESP_8266_RFID
  |  |  |  |-functions.json
  |  |  |  |-settings_TEMPLATE.json
  |  |  |-ESP_8266_Sensors
  |  |  |  |-functions.json
  |  |  |  |-settings_99_Lab8266.json
  |  |  |  |-settings_TEMPLATE.json
  |  |-OpenHAB
  |  |  |-API
  |  |  |  |-ESP_32_Cam
  |  |  |  |  |-items_TEMPLATE.json
  |  |  |  |  |-links_TEMPLATE.json
  |  |  |  |  |-rules_TEMPLATE.json
  |  |  |  |  |-things_98_Lab32.json
  |  |  |  |  |-things_98_Lab32_0.json
  |  |  |  |  |-things_TEMPLATE.json
  |  |  |  |-ESP_8266_RFID
  |  |  |  |  |-items_TEMPLATE.json
  |  |  |  |  |-links_TEMPLATE.json
  |  |  |  |  |-rules_TEMPLATE.json
  |  |  |  |  |-things_TEMPLATE.json
  |  |  |  |-ESP_8266_Sensors
  |  |  |  |  |-items_TEMPLATE.json
  |  |  |  |  |-links_TEMPLATE.json
  |  |  |  |  |-rules_TEMPLATE.json
  |  |  |  |  |-things_99_Lab8266.json
  |  |  |  |  |-things_99_Lab8266_0.json
  |  |  |  |  |-things_TEMPLATE.json
  |  |  |  |-items.json
  |  |  |-map
  |  |  |  |-lamp.map
  |  |  |  |-switch.map
  |  |  |-web_pages
  |  |  |  |-ESP_32_Cam
  |  |  |  |  |-overview.yml
  |  |  |  |  |-overview_98_Lab32.yml
  |  |  |  |  |-overview_HEADER.yml
  |  |  |  |  |-overview_TEMPLATE.yml
  |  |  |  |  |-page_98_Lab32.yml
  |  |  |  |  |-page_TEMPLATE.yml
  |  |  |  |-ESP_8266_RFID
  |  |  |  |  |-overview.yml
  |  |  |  |  |-overview_HEADER.yml
  |  |  |  |  |-overview_TEMPLATE.yml
  |  |  |  |  |-page_TEMPLATE.yml
  |  |  |  |-ESP_8266_Sensors
  |  |  |  |  |-overview.yml
  |  |  |  |  |-overview_99_Lab8266.yml
  |  |  |  |  |-overview_HEADER.yml
  |  |  |  |  |-overview_TEMPLATE.yml
  |  |  |  |  |-page_99_Lab8266.yml
  |  |  |  |  |-page_TEMPLATE.yml
  |  |-provisioning.sh
  |  |-runs.log
  |  |-settings.ini
  |  |-test.log
  |  |-trace.log
  |-README.md
  |-RELEASE.md
  |-sample.env
  |-TODO.md
````
