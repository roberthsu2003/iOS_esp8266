#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>

//OLED
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>


//OLED-----------
// SCL GPIO5
// SDA GPIO4
#define OLED_RESET 0  // GPIO0
Adafruit_SSD1306 display(OLED_RESET);

#define NUMFLAKES 10
#define XPOS 0
#define YPOS 1
#define DELTAY 2


#define LOGO16_GLCD_HEIGHT 16
#define LOGO16_GLCD_WIDTH  16
//OLED-----------

#define FIREBASE_HOST "iostes.firebaseio.com"
#define WIFI_SSID "robe"
#define WIFI_PASSWORD "06000"


//OLED---
String content = "default value";
//OLED---

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
  
  Firebase.begin(FIREBASE_HOST);
 
  
  
  //OLED--------------
   display.begin(SSD1306_SWITCHCAPVCC, 0x3C);  // initialize with the I2C addr 0x3C or 0x3D (for the 64x48)
  // init done
  display.display();
  delay(1000);
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(0, 0);  
  display.println(content);
  display.display();
  //OLED------------
}

void loop() {
  
  if(Firebase.success()){
    

      //OLED-----------
      String newContent = Firebase.getString("Content/message");
      if (!content.equals(newContent)){
          content = newContent;
          display.clearDisplay();
          display.setCursor(0,0);
          display.println(content);
          display.display();
        }
      
      //OELD----------
      
    
    
    
  }else{
     Serial.println("取得Firebase Data 失敗");     
  }
  
  
 
  delay(200); 

}
