from machine import Pin #LIbreríia para el control de los pines
import network #Libreria para la conexion a internet
import time #Libreria time para generar delays
from umqtt.simple import MQTTClient #Libreria para crear un cliente MQTT
import math #Libreria para algunas operaciones matemáticas

ssid = "LNK_INV_DESARROLLO"
password = "@Linktek2019@"

#Thermistor
thermistor = machine.ADC(27)
sensibilidad = 1.0/65536 #(1/LSB)
volt_max = 3.3 #voltaje fuente del divisor
T0 = 298.15 #Temperatura ambiente en kelvin
R0 = 100000 #Resitencia del therm a temperatura ambiente
B = 4250 #Constante B

def wlan_connect():
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.connect(ssid, password)
    
    max_wait = 10
    while max_wait > 0:
        if wlan.status() < 0 or wlan.status() >= 3:
            break
        max_wait -= 1
        print('esperando conexion...')
        time.sleep(1)
    
    if wlan.status() != 3:
        raise RuntimeError('fallo de conexion')
    else:
        print('conectado')
        status = wlan.ifconfig()
        print('ip = ' + status[0])

def mqtt_connect():
    client = MQTTClient(client_id = "picow_board_1",
                        server = "test.mosquitto.org",
                        port = 1883, user = None,
                        password = None,
                        keepalive = 3600,
                        ssl = False,
                        ssl_params = {})
    client.connect()
    return client

def publish(topic, value):
    print(topic)
    print(value)
    client.publish(topic, value)
    print("publicacion hecha")
    
wlan_connect()
time.sleep(3)
client = mqtt_connect()

while 1:
    therm = thermistor.read_u16()
    voltaje = volt_max * therm * sensibilidad
    resistencia = (voltaje * 470000)/(3.3 - voltaje)
    T_inv = (1/T0) + (1/B) * math.log(resistencia/R0)
    T = str(round((1/ T_inv) - 273.15,1))
    print(T)
    
    publish(b'picowboard/test', T)
    time.sleep(10)