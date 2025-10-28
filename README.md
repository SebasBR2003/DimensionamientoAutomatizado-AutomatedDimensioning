# ☀️Automated-dimensioning-for-solar-panels☀️ 

Este repositorio contiene un script de MATLAB diseñado para el dimensionamiento de un sistema de energía fotovoltaica (FV) interconectado a la red, utilizando como base el consumo de energía neto anual registrado en los recibos de luz.

El script realiza el cálculo del número óptimo de módulos FV requeridos y verifica la compatibilidad eléctrica con un microinversor o un inversor central propuesto, además de calcular parámetros eléctricos clave para el diseño del circuito de salida (calibres, protecciones y caída de tensión).

🎯Parámetros utilizados🎯

Este dimensionamiento está configurado para un caso de estudio en Mérida, Yucatán, México.

1. Datos de consumo y ubicación🏡
   
Los datos de consumo se extrajeron de un recibo de luz de uso doméstico ubicado en Mérida, Yucatán. El cálculo se basa en un Consumo Neto Anual de aproximadamente 7949 kWh/año (la suma de los 6 bimestres sin subsidio). La ubicación utiliza un valor promedio de Horas de Sol Pico (HSP) de 6.1 h y se aplica un Factor de Pérdidas del sistema de 0.77, lo que implica unas pérdidas estimadas del 23%.

2. Equipamiento seleccionado⚡

El Panel Solar elegido es un modelo Jinko Solar Tiger Neo con una Potencia Máxima en STC de 580 Wp. El equipo de inversión seleccionado para la verificación es el Microinversor Hoymiles HMS-2000DW-4T (2000 W).

3. Parámetros climáticos🌡️
   
Para verificar la compatibilidad eléctrica en condiciones extremas, se consideran los siguientes datos climáticos de la ubicación:Temperatura mínima de 17°C, utilizada para calcular la tensión máxima del arreglo.Temperatura máxima de 42.4°C, utilizada para calcular la tensión mínima de operación.

---------------------------------------------------------------

This repository contains a MATLAB script designed for sizing a grid-tied Photovoltaic (PV) energy system, using the annual net energy consumption data registered on electricity bills as the basis.

The script calculates the optimal number of required PV modules and checks the electrical compatibility with a proposed microinverter or central inverter, in addition to calculating key electrical parameters for the output circuit design (wire gauges, protection, and voltage drop).

🎯 Parameters used 🎯

This sizing is configured for a case study in Mérida, Yucatán, Mexico.

1. Consumption and location data🏡
   
The consumption data was extracted from a domestic electricity bill located in Mérida, Yucatán. The calculation is based on an Annual Net Consumption of approximately 7949 kWh/year (the sum of the 6 bimonthly periods without subsidy). The location uses an average Peak Sun Hours (PSH) value of 6.1 h, and a system Loss Factor of 0.77 is applied, which implies an estimated loss of 23%.

3. Selected equipment⚡
   
The chosen Solar Panel is a Jinko Solar Tiger Neo model with a Maximum Power at STC of 580 Wp. The inversion equipment selected for verification is the Hoymiles HMS-2000DW-4T Microinverter (2000 W).

5. Climatic parameters🌡️
   
To verify electrical compatibility under extreme conditions, the following climatic data for the location are considered:Minimum Temperature of 17°C, used to calculate the array's maximum voltage.Maximum Temperature of 42.4°C, used to calculate the minimum operating voltage.
