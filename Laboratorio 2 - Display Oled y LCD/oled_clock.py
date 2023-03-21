from machine import Pin, I2C
from ssd1306 import SSD1306_I2C
import utime

#I2C address
RX8010SJ_ADDR = 0X32
#Registros
REG_TIME = 0X10

#Inicializar I2C
i2c = machine.I2C(1, scl = Pin(15), sda = Pin(14), freq = 200000)

#Inicializar el oled
oled = SSD1306_I2C(128, 32, i2c)

#Main program
while 1:
    #Lee los valores de H, M y S de los registros
    time = i2c.readfrom_mem(RX8010SJ_ADDR, REG_TIME, 3)
    
    #Converitmos los bytes en un string hexadecimal
    time_s = time.hex()[0:2]
    time_m = time.hex()[2:4]
    time_h = time.hex()[4:6]
    print(time_h, ":", time_m, ":", time_s)
    
    #limpiar la pantalla en caso tenga pixeles encendidos
    oled.fill(0)
    
    #añadir texto
    oled.text("H  M  S", 10, 8)
    oled.text(time_h, 5, 20)
    oled.text(":", 20, 20)
    oled.text(time_m, 30, 20)
    oled.text(":", 45, 20)
    oled.text(time_s, 55, 20)
    
    #mostrar
    oled.show()
    utime.sleep(0.5)