#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <Adafruit_NeoPixel.h>


#define RelayPin D1
#define RGBPIN D2
#define FIREBASE_HOST "iostest.firebaseio.com"
#define WIFI_SSID "robert"
#define WIFI_PASSWORD "092"

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(1, RGBPIN, NEO_GRB + NEO_KHZ800);

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
  pixels.begin(); // This initializes the NeoPixel library.
}

void loop() {
  
  if(Firebase.success()){
    bool d1Value = Firebase.getBool("Relay/D1");
    digitalWrite(RelayPin,d1Value);
    int rValue = Firebase.getInt("RGB/R");
    int gValue = Firebase.getInt("RGB/G");
    int bValue = Firebase.getInt("RGB/B");
    pixels.setPixelColor(0, pixels.Color(rValue, gValue, bValue));
    pixels.show();
  }else{
     Serial.println("取得Firebase Data 失敗");     
  }
  
  
 
  delay(200); 

}
