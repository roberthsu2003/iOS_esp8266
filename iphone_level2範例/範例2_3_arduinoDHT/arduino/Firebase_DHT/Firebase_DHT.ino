#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <Adafruit_NeoPixel.h>
#include <DHT.h>


#define RelayPin D1
#define RGBPIN D2
#define DHTPIN D4 
#define DHTTYPE DHT11   // DHT 11
#define FIREBASE_HOST "iostest.firebaseio.com"
#define WIFI_SSID "robert"
#define WIFI_PASSWORD "06000"

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(1, RGBPIN, NEO_GRB + NEO_KHZ800);

DHT dht(DHTPIN, DHTTYPE);
unsigned long lastDHTTime = 0;

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
  
  dht.begin();
  lastDHTTime = millis();
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

    if((millis() - lastDHTTime) > 2000){
      float h = dht.readHumidity();
      float t = dht.readTemperature();
      float f = dht.readTemperature(true);
      if (isnan(h) || isnan(t) || isnan(f)) {
        Serial.println("Failed to read from DHT sensor!");
        return;
      }
      // Compute heat index in Fahrenheit (the default)
      float hif = dht.computeHeatIndex(f, h);
      // Compute heat index in Celsius (isFahreheit = false)
      float hic = dht.computeHeatIndex(t, h, false);

      Serial.print("Humidity: ");
      Serial.print(h);
      Serial.print(" %\t");
      Serial.print("Temperature: ");
      Serial.print(t);
      Serial.print(" *C ");
      Serial.print(f);
      Serial.print(" *F\t");
      Serial.print("Heat index: ");
      Serial.print(hic);
      Serial.print(" *C ");
      Serial.print(hif);
      Serial.println(" *F");  
      
      Firebase.setString("DHT/Humidity",String(String(h)+"%"));
      Firebase.setString("DHT/Celsius",String(String(t)+"*C"));
      Firebase.setString("DHT/CelsiusIndex",String(String(hic)+"*C"));
      Firebase.setString("DHT/Fahrenheit",String(String(f)+"*F"));
      Firebase.setString("DHT/FahrenheitIndex",String(String(hif)+"*F"));
      lastDHTTime = millis();
      
    }
    
    
  }else{
     Serial.println("取得Firebase Data 失敗");     
  }
  
  
 
  delay(200); 

}
