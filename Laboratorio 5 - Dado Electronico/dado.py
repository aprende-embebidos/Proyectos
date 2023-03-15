from machine import Pin #Librería para el control de los Pines
import random as rn #Librería para generar un número aleatorio
import time #Librería para generar delays


roll = Pin(6, Pin.IN) #Inicializamos el Pin que indica cuando lanzar los ddados

#Inicializamos los pines por los que mandaremos el resutado del DADO 1 al FPGA
dado_1 = []
for i in range(0,3):
    dado_1.append(Pin(i, Pin.OUT))

#Inicializamos los pines por los que mandaremos el resutado del DADO 2 al FPGA
dado_2 = []
for j in range(3,6):
    dado_2.append(Pin(j, Pin.OUT))

#Main
while True:
    if (roll.value() == 1):
        
        #Generamos los numeros aleatorios para cada dado y los convertimos a binario
        d1 = '{0:03b}'.format(rn.randint(1,6))
        d2 = '{0:03b}'.format(rn.randint(1,6))
        
        #Asignamos los balores de los bits del DADO 1 a sus pines de salida
        for d, dado in enumerate(d1):
            dado_1[d].value(int(dado))
            
        #Asignamos los balores de los bits del DADO 2 a sus pines de salida
        for d, dado in enumerate(d2):
            dado_2[d].value(int(dado))
        
        time.sleep(0.3) #Delay de medio segundo antes de poder lanzar otra vez
        
    else:
        
        time.sleep(0.1) #Delay de 0.1 segundos si es que no hay ningun lanzamiento