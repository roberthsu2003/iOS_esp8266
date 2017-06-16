#include <Wire.h>
#include <Adafruit_BMP085.h>
 
Adafruit_BMP085 bmp;
 
void setup() 
{
  Serial.begin(9600);
  //Wire.begin (4, 5);
  if (!bmp.begin()) 
  {
    Serial.println("Could not find BMP180 or BMP085 sensor at 0x77");
    while (1) {}
  }
}
 
void loop() 
{
  Serial.print("Temperature = "); // 溫度
  Serial.print(bmp.readTemperature());
  Serial.println(" Celsius");
 
  Serial.print("Pressure = "); // 大氣壓力
  // 101325 pa 標準
  // 每上升10公尺氣壓下降100Pa
  Serial.print(bmp.readPressure());
  Serial.println(" Pascal");
  float m = (101325-bmp.readPressure())/10;
  
  Serial.print(m);
  Serial.println(" m");
 
  Serial.println();
  delay(5000);
}
