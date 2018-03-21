#include <Arduino.h>
#include <AsyncMqttClient.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <Ticker.h>

#define MQTT_HOST IPAddress(192, 168, 1, 2)
#define MQTT_PORT 1883

#define led_pin 5
#define button_pin 16
int button_state = 0;
int previous_state = -1;

AsyncMqttClient mqttClient;
Ticker mqttReconnectTimer;

WiFiEventHandler wifiConnectHandler;
WiFiEventHandler wifiDisconnectHandler;
Ticker wifiReconnectTimer;

void connectToWifi() {
  Serial.println("Connecting to Wi-Fi...");
  WiFi.begin("WIFI_SSID", "WIFI_PASSWORD_HERE");
}

void connectToMqtt() {
  Serial.println("Connecting to MQTT...");
  mqttClient.connect();
}

void onWifiConnect(const WiFiEventStationModeGotIP &event) {
  Serial.println("Connected to Wi-Fi.");
  connectToMqtt();
}

void onWifiDisconnect(const WiFiEventStationModeDisconnected &event) {
  Serial.println("Disconnected from Wi-Fi.");
  mqttReconnectTimer.detach(); // ensure we don't reconnect to MQTT while
                               // reconnecting to Wi-Fi
  wifiReconnectTimer.once(2, connectToWifi);
}

void onMqttConnect(bool sessionPresent) {
  Serial.println("Connected to MQTT.");
  uint16_t packetIdSub = mqttClient.subscribe("MQTT_CHANNEL/HERE", 2);
}

void onMqttDisconnect(AsyncMqttClientDisconnectReason reason) {
  Serial.println("Disconnected from MQTT.");

  if (reason == AsyncMqttClientDisconnectReason::TLS_BAD_FINGERPRINT) {
    Serial.println("Bad server fingerprint.");
  }

  if (WiFi.isConnected()) {
    mqttReconnectTimer.once(2, connectToMqtt);
  }
}

void onMqttMessage(char *topic, char *payload,
                   AsyncMqttClientMessageProperties properties, size_t len,
                   size_t index, size_t total) {

    // Mqtt actions here
    if(topic == (std::string) "MQTT_CHANNEL/HERE"){
    	digitalWrite(led_pin, (payload == (std::string)"0"? LOW: HIGH));
  	}
}

void onMqttPublish(uint16_t packetId) {
  Serial.println("Publish acknowledged.");
  Serial.print("  packetId: ");
  Serial.println(packetId);
}

void setup() {
  Serial.begin(115200);
  pinMode(led_pin, OUTPUT);
  pinMode(button_pin, INPUT);

  digitalWrite(led_pin, LOW);

  wifiConnectHandler = WiFi.onStationModeGotIP(onWifiConnect);
  wifiDisconnectHandler = WiFi.onStationModeDisconnected(onWifiDisconnect);

  mqttClient.onConnect(onMqttConnect);
  mqttClient.onDisconnect(onMqttDisconnect);
  mqttClient.onMessage(onMqttMessage);
  mqttClient.onPublish(onMqttPublish);
  mqttClient.setServer(MQTT_HOST, MQTT_PORT);

  connectToWifi();
}

void loop() {
  button_state = digitalRead(button_pin);

  if(button_state != previous_state){
    if(button_state == HIGH){
      Serial.println("DOWN");
      mqttClient.publish("MQTT_CHANNEL/HERE", 0, true, "1");
    }else{
      Serial.println("UP");
      mqttClient.publish("MQTT_CHANNEL/HERE", 0, true, "0");
    }
    previous_state = button_state;
  }
}
