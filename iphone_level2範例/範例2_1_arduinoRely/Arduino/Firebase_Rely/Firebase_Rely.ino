/*
 * Relay Shield - Blink
 * Turns on the relay for two seconds, then off for two seconds, repeatedly.
 *
 * Relay Shield transistor closes relay when D1 is HIGH
 */
#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>

#define RelayPin D1
#define FIREBASE_HOST "iostest.firebaseio.com" //輸入Firebase database專案的位址，不要http://
#define WIFI_SSID "iP" //輸入wifi ssid
#define WIFI_PASSWORD "09" //請輸入密碼

void setup() {
  Serial.begin(115200);
  //連線到Wifi
  WiFi.begin(WIFI_SSID,WIFI_PASSWORD);
  Serial.print("開始連線");
  while(WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("連線成功:");
  Serial.print(WiFi.localIP());
  pinMode(RelayPin,OUTPUT);
  Firebase.begin(FIREBASE_HOST);
}

void loop() {
  
  if (Firebase.success()){
    bool d1Value = Firebase.getBool("Relay/D1");
    digitalWrite(RelayPin,d1Value);
  }else{
    Serial.println("取得Relay/D1失敗，重新執行");    
  }
  
  delay(200); 

}
