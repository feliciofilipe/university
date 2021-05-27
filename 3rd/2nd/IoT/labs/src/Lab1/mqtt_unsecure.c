/* Arduino MQTT client using MKR WIFI 1010 board. 
* Author: Sudeep Kanur
* Email: skanur@abo.fi
* License: MIT
*/
//Open the serial monitor from Tools->Serial Monitor

// WiFiNINA - Version: Latest 
#include <WiFiNINA.h>

// ArduinoMqttClient - Version: Latest 
#include <ArduinoMqttClient.h>
#include "arduino_secrets.h" // you need to create this header file (open a new tab) containing:
//#define SECRET_SSID "BUFFALO2"
//#define SECRET_PASS "pleaseletmein"

#define TEMPSENSOR A0 //analog input pin

///////please enter your sensitive data in a filearduino_secrets.h (open a new tab)
char ssid[] = SECRET_SSID;        // your network SSID (name)
char pass[] = SECRET_PASS;    // your network password (use for WPA, or use as key for WEP)
String group = "MyGroup";   // UPDATE THIS with an unique name for your group
int status = WL_IDLE_STATUS;

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);

const char broker[] = "broker.hivemq.com";
int        port     = 1883;
String responseTopic  = "saiot/19/" + group + "/response";
String commandTopic = "saiot/19/" + group + "/command";

// Time related functions
const unsigned long interval = 1000;
unsigned long previousMillis = 0;
unsigned long previousMessageTime = 0;

void setup() {
  // Initialize serial and wait for port to open
  Serial.begin(9600);
  
  // Check for WiFi module
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed.");
    exit(0);
  }
  
  String fv = WiFi.firmwareVersion();
  if (fv < "1.0.0") {
    Serial.println("Please upgrade the firmware.");
  }
  
  // attempt to connect to WiFi
  while (status != WL_CONNECTED) {
    Serial.print("Attempting to connect to WPA SSID:");
    Serial.println(ssid);
    // Connect to WPA/WPA2 network
    status = WiFi.begin(ssid, pass);
    
    // wait for 10 seconds for connection
    delay(10000);
  }
  
  // You're connected now. So print out the data
  Serial.print("You're connected to the network");
  printCurrentNet();
  printWifiData();

  Serial.print("Attempting to connect to the MQTT broker: ");
  Serial.println(broker);
  
  if(!mqttClient.connect(broker, port)) {
    Serial.print("MQTT connection failed! Error code = ");
    Serial.println(mqttClient.connectError());

    exit(0);
  }
  
  // set the message receive callback
  mqttClient.onMessage(onMqttMessage);

  Serial.print("Subscribing to topic: ");
  Serial.println(commandTopic);
  Serial.println();

  // subscribe to a topic
  // the second paramter set's the QoS of the subscription,
  // the the library supports subscribing at QoS 0, 1, or 2
  int subscribeQos = 1;

  mqttClient.subscribe(commandTopic, subscribeQos);

  Serial.println("You're connected to MQTT broker!");
}

void loop() {
    // Call poll() regularly to allow the library to send MQTT keep alives which
    // avoids being disconnected by the broker
    mqttClient.poll();

    // Instead of having delays, which could affect polling, we do this
    unsigned long currentMillis = millis();

    if (currentMillis - previousMillis >= interval) {
        // save the last time a message was sent
        

        Serial.print("Sending message to topic: ");
        Serial.println(responseTopic);
        Serial.print("Latency of previous message: ");
        Serial.print(currentMillis - previousMillis);
        Serial.print(" us.");

        float temperature = getTemp();
        mqttClient.beginMessage(responseTopic);
        mqttClient.print(temperature);
        mqttClient.print(" deg. C");
        mqttClient.endMessage();
        previousMillis = currentMillis;

        Serial.println();
    }
}

void printWifiData() {
  // print your board's IP address
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);
  Serial.println(ip);
  
  // Print your MAC address
  byte mac[6];
  WiFi.macAddress(mac);
  Serial.print("MAC address: ");
  printMacAddress(mac);
}

void printCurrentNet() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID:");
  Serial.println(WiFi.SSID());
  
  // print the mac address of the router you're attached to
  byte bssid[6];
  WiFi.BSSID(bssid);
  Serial.print("BSSID: ");
  printMacAddress(bssid);
  
  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.println(rssi);

  // print the encryption type:
  byte encryption = WiFi.encryptionType();
  Serial.print("Encryption Type:");
  Serial.println(encryption, HEX);
  Serial.println();
}

void printMacAddress(byte mac[]) {
  for (int i = 5; i >= 0; i--) {
    if (mac[i] < 16) {
      Serial.print("0");
    }
    Serial.print(mac[i], HEX);
    if (i > 0) {
      Serial.print(":");
    }
  }
  Serial.println();
}

float getTemp() {
    float voltage_at_0 = 0.5;        // From MCP9700 datasheet. Voltage at 0 C.
    float temp_coefficient = 0.01;   // From MCP9700 datasheet. 10mv/1 C
    float ambient_temperature = 0.0; // Store the ambient temperature reading
    float temperature = 0.0;         // Store the final reading
    float ten_sample_sum = 0.0;      // Store sum of 10 samples

    // take 10 samples from MCP9700
    for(int sample = 0; sample < 10; sample++) {
        // Read ambient temperature and convert to voltage
        ambient_temperature = (float) analogRead(TEMPSENSOR) * 3.3 / 1024.0;
        temperature = (ambient_temperature - voltage_at_0)/temp_coefficient;

        // Sample every 0.1 seconds
        delay(100);

        ten_sample_sum += temperature;
    }

    // Get the average and return;
    return (ten_sample_sum / 10.0);
}

void onMqttMessage(int messageSize) {
  // we received a message, print out the topic and contents
  Serial.print("Received a message with topic '");
  Serial.print(mqttClient.messageTopic());
  Serial.print("', duplicate = ");
  Serial.print(mqttClient.messageDup() ? "true" : "false");
  Serial.print(", QoS = ");
  Serial.print(mqttClient.messageQoS());
  Serial.print(", retained = ");
  Serial.print(mqttClient.messageRetain() ? "true" : "false");
  Serial.print("', length ");
  Serial.print(messageSize);
  Serial.println(" bytes:");

  // use the Stream interface to print the contents
  while (mqttClient.available()) {
    Serial.print((char)mqttClient.read());
  }
  Serial.println();
  Serial.println();
}