% Estas 3 líneas no borrarlas, sirve para limpiar el workspace y trabajar desde cero
clc
clear all
close all

% CÓDIGO MATLAB PARA DIMENSIONAMIENTO FOTOVOLTAICO BASADO EN CONSUMO NETO ANUAL



% ---> MICROINVERSOR <---



% ==================================================
% PARÁMETROS DE ENTRADA (A MODIFICAR POR EL USUARIO)
% ==================================================

% 1. Datos de consumo y subsidio bimestral (kWh)
% Define la energía consumida TOTAL y el SUBSIDIO aplicado para 6 períodos bimestrales.
fprintf('\n<strong>ENTRADA DE DATOS DE CONSUMO TOTAL Y SUBSIDIO BIMESTRAL (kWh)</strong>');

% Consumo total registrado en el recibo (kWh)
Consumo_Total_Bimestral = [
    1618;  % Bimestre 1: 17 Jun 24 - 15 Ago 24
    1480;  % Bimestre 2: 15 Ago 24 - 15 Oct 24
    958;   % Bimestre 3: 15 Oct 24 - 16 Dic 24
    728;   % Bimestre 4: 16 Dic 24 - 12 Feb 25
    1122;  % Bimestre 5: 12 Feb 25 - 14 Abr 25
    2039   % Bimestre 6: 14 Abr 25 - 16 Jun 25
];

% Subsidio aplicado (kWh)
Subsidio_Bimestral = [
    0;  % Bimestre 1: 17 Jun 24 - 15 Ago 24
    0;  % Bimestre 2: 15 Ago 24 - 15 Oct 24
    0;  % Bimestre 3: 15 Oct 24 - 16 Dic 24
    0;  % Bimestre 4: 16 Dic 24 - 12 Feb 25
    0;  % Bimestre 5: 12 Feb 25 - 14 Abr 25
    0   % Bimestre 6: 14 Abr 25 - 16 Jun 25
];

% 2. Parámetros de ubicación y pérdidas (Mérida, Yucatán)
HSP = 6.1;              % (h) Horas de Sol Pico (HSP) promedio anual de la ubicación
Factor_Perdidas = 0.77; % Factor de Pérdidas del Sistema (0.77 = 23% de pérdidas)

% 3. Ficha Técnica del Panel Solar Candidato (Condiciones Standard Test Condition [STC])
Potencia_MFV_STC = 580; % Potencia Máxima del Módulo Fotovoltaico (MFV) en STC


% =========================================
% CÁLCULOS DE ENERGÍA Y POTENCIA REQUERIDA
% =========================================

fprintf('\n\n<strong>=== CÁLCULOS DE DIMENSIONAMIENTO: MICROINVERSOR ===</strong>\n\n');

% PASO 1: Obtener el CONSUMO NETO (la diferencia entre el total y el subsidio) para cada bimestre
Consumo_Neto_Bimestral = Consumo_Total_Bimestral - Subsidio_Bimestral;
fprintf('Consumo neto (Energía a cubrir por el FV) por bimestre:\n');
disp(Consumo_Neto_Bimestral);

% PASO 2: Obtener el TOTAL ANUAL (sumando las diferencias bimestrales)
E_consumida_anual_neta = sum(Consumo_Neto_Bimestral); % (kWh/año)
fprintf('Energía neta a cubrir anual: %.0f kWh/año\n', E_consumida_anual_neta);

% PASO 3: Obtener el PROMEDIO DIARIO de energía requerido
E_requerida_diaria = E_consumida_anual_neta / 365; % (kWh/día)
fprintf('Energía Requerida Diaria Promedio: %.2f kWh/día\n', E_requerida_diaria);

% PASO 4: Obtener la POTENCIA FV nominal requerida
P_FV = E_requerida_diaria / (HSP * Factor_Perdidas); % (kW)
fprintf('Potencia FV Nominal Requerida: %.2f kW\n', P_FV);

% PASO 5: Obtener el NÚMERO DE MÓDULOS FV (P_FV se convierte kW -> W)
N_modulos = (P_FV * 1000) / Potencia_MFV_STC;

% PASO 6: Redondear al entero superior  (arriba de 0.3 se redondea arriba,
% si no, para abajo)
Parte_Decimal = mod(N_modulos, 1);
Umbral = 0.3;

if Parte_Decimal >= Umbral
    % Redondea siempre hacia arriba con ceil() si el umbral se cumple
    N_modulos_final = ceil(N_modulos);
else
    % Redondea siempre hacia abajo con fix() si no se cumple
    N_modulos_final = fix(N_modulos); 
end

fprintf('\nNúmero de módulos FV calculados (decimal): %f\n', N_modulos);
fprintf('Número de módulos FV final (redondeado): ☀️ %d módulos fotovoltaicos ☀️️\n', N_modulos_final);

% PASO 7: ELEGIR PANEL
fprintf('\n<strong>PANEL SOLAR ELEGIDO: Panel Solar Jinko Solar – N-Type Topcon – Tiger Neo – 580W</strong>');

% PROVEEDOR MEX https://enertik.com/mx/tienda/fotovoltaica/paneles-solares/panel-solar-jinko-solar-n-type-topcon-tiger-neo-580w/
% DATASHEET https://jinkosolarcdn.shwebspace.com/uploads/JKM565-585N-72HL4-(V)-F3-EN.pdf

Pmax = Potencia_MFV_STC;     % (W) Maximum Power
Vmp = 42.37;                 % (V) Maximum Power Voltage
Voc = 51.02;                 % (V) Open-circuit Voltage
Isc = 14.47;                 % (A) Short-circuit Voltage

T_min = 17;             % (°C) Temperatura mínima en Mérida en los últimos 10 años
T_max = 42.4;           % (°C) Temperatura máxima en Mérida en los últimos 10 años
T_STC = 25;             % (°C) Temperatura en STC
Coef_T_VOC = -0.25;     % (%/°C) Coeficiente de temperatura Voc
Coef_T_Pmax = -0.29;    % (%/°C) Coeficiente de temperatura Pmax


% PASO 8: TENSIÓN MÁXIMA en Maximum Power Point Tracking (MPPT)
Dif_temp_max = T_min - T_STC;
Incremento = abs(Dif_temp_max * Coef_T_VOC) / 100;
Tension_max = (1 + Incremento) * Voc; % (V)

% PASO 9: TENSIÓN MÍNIMA en MPPT
Dif_temp_min = 30 + T_max - T_STC;
Decremento = abs(Dif_temp_min * Coef_T_Pmax) / 100;
Tension_min = (1 - Decremento) * Vmp; % (V)

fprintf('\nTensión Máxima MPPT: %.2f V\n', Tension_max);
fprintf('Tensión Mínima MPPT: %.2f V\n', Tension_min);


% =========================================================
% PASO 10: VERIFICACIÓN DE COMPATIBILIDAD CON MICROINVERSOR
% =========================================================

fprintf('\n<strong>MICROINVERSOR ELEGIDO: Hoymiles HMS-2000DW-4T</strong>');

% DATASHEET https://www.hoymiles.com/uploadfile/1/202506/ac1a50f235.pdf
% PROVEEDOR MEX https://www.syscom.mx/producto/HMS2000DW4T-HOYMILES-240948.html

Compatibilidad_min = 400;                   % (W)
Compatibilidad_max = 670;                   % (W)
Tension_max_registro_corriente_min = 16;    % (V)
Tension_max_registro_corriente_max = 60;    % (V)
Intervalo_func_min = 22;                    % (V)
Intervalo_func_max = 60;                    % (V)
modulo_Isc = 20;                            % (A)

fprintf('\n\nVERIFICACIÓN DE COMPATIBILIDAD ELÉCTRICA (Panel vs. Microinversor)');

% Criterios de compatibilidad

% 1. Chequeo de rango de potencia 
if (Pmax > Compatibilidad_min && Pmax < Compatibilidad_max)
    Check_Pmax = true;
end

% 2. Chequeo de rango MPPT (Eficiencia)
if (Vmp > Tension_max_registro_corriente_min && Vmp < Tension_max_registro_corriente_max && ...
       Tension_min > Tension_max_registro_corriente_min && Tension_max < Tension_max_registro_corriente_max)
   Check_V_MPPT = true;
end

% 3. Cheque de intervalo de funcionamiento (Seguridad)
if (Voc > Intervalo_func_min && Voc < Intervalo_func_max)
    Check_V_Voc = true;
end

% 4. Chequeo de corriente máxima
Check_I_Max = Isc < modulo_Isc;

% Usamos la función check_status para formatear la salida
fprintf('\n1. Compatibilidad de Potencia (Pmax): %s\n', check_status(Check_Pmax));
fprintf('2. Rango MPPT (Vmp): %s\n', check_status(Check_V_MPPT));
fprintf('3. Intervalo de Operación (Voc): %s\n', check_status(Check_V_Voc));
fprintf('4. Corriente Máxima (Isc): %s\n', check_status(Check_I_Max));

% Función auxiliar para mostrar SI/NO con emojis
function result_status = check_status(value)
    if value
        result_status = '✅ SÍ Compatible';
    else
        result_status = '❌ NO Compatible (Revisar)';
    end
end


% =========================================================================
% PASO 11: MEDIO DE DESCONEXION Y MEDIOS DE PROTECCION CONTRA SOBRECORRIENTE
% =========================================================================

% 1.- Determinar la corriente máxima del circuito de salida del inversor
Max_cont_out_P = 2000; % (W) Potencia de salida continua máxima
Nominal_out_V = 220;   % (V) Voltaje nominal de salida

I_max_cont = Max_cont_out_P/Nominal_out_V;  % (A) Corriente máxima continua

% 2.- Determinar medio de desconexión y medio de protección
NumMicroinv = 2;

Medio_desconexion = I_max_cont * NumMicroinv * 1.25;    % (A)

% Revisar tabla 310-15(b)(16) para elegir calibre del conductor

fprintf('\n<strong>DETALLES DEL CONDUCTOR</strong>\n\n');
fprintf('Material: Cobre');
fprintf('Ampacidad permisible más cercana a %.2f A a 75°C: 15 A\n', Medio_desconexion);
fprintf('Calibre: 12 AWG');

% 3.- Revisar tabla 310-15(b)(2)(a), encontrar el factor de corrección de
% acuerdo a la temperatura ambiente correspondiente a Mérida, Yucatán
Factor_correccion = 1.00;

fprintf(['\n\nLa temperatura ambiente es de 26°C, por lo tanto el factor de corrección de acuerdo a la tabla ' ...
    'es de 1.00.\n']);
fprintf(['Esto quiere decir que no hay cambio en la ampacidad obtenida anteriormente']);

% 4.- Calcular la ampacidad requerida
% Revisar tabla 310-15(b)(16), encontrar calibre AWG ideal para los conductores 

Max_I_cont = Medio_desconexion;     % (A) Corriente máxima del circuito de salida del inversor
Factor_NumConduct = 1;              % Factor de corrección por número de conductores

Amp_req = Max_I_cont/Factor_correccion/Factor_NumConduct;   % (A) Ampacidad requerida en los conductores

fprintf(['\n\nAmpacidad requerida = %.2f A. ' ...
    'Esto implica un conductor 12 AWG siempre y cuando esté conectado a una terminal de 75°C.\n'], Amp_req);

% =========================
% PASO 12: CAIDA DE TENSION
% =========================

fprintf('\n<strong>CAIDA DE TENSION</strong>');

% Buscar resistencia en corriente continua en 
% https://imgv2-2-f.scribdassets.com/img/document/584113751/original/98e54a0e49/1?v=1

Distancia = 7.5;                                % (m) distancia desde la planta baja hasta el techo de la casa
Resistencia_Icont = 6.73;                       % (Ω/km) Resistencia en corriente continua a 75°C, Cobre, Recubierto, 
                                                % 7 hilos, 12 AWG
I_max_out_microinv = I_max_cont * NumMicroinv;  % (A) Corriente de salida máxima del microinversor

eT = ((2*Distancia*I_max_out_microinv)/1000)*Resistencia_Icont; % (V) Caída de tensión 
eporcentaje = (eT/Nominal_out_V)*100;                           % (%) Porcentaje de caída de tensión

fprintf('\n\nCaída de tensión = %.2f V\n', eT)
fprintf('Porcentaje de caída de tensión = %.2f﹪, es menor a 2﹪ por lo tanto no hay pérdidas.\n', eporcentaje)

% =====================
% PASO 13: CANALIZACION
% =====================

fprintf('\n<strong>CANALIZACION</strong>');

% Area del 12 AWG obtenida en 
% https://mascapacitacion.com.mx/wp-content/uploads/2022/05/Tabla.png

Num_conduct = 3;                % Numero de conductores (L1,L2 y puesta a tierra)
Area_AWG = 11.68;               % (mm²) Area aproximada del 12 AWG  

Atotal = Num_conduct*Area_AWG;  % (mm²) Area total

fprintf(['\nDe acuerdo a la tabla Artículo 344-Tubo conduit metálico pesado (RMC), el tamaño comercial ' ...
    'con área más cercana a la obtenida, es de ½.\n'])
fprintf('La canalización de ½ fácilmente otorga el 60﹪ de espacio libre.')



% ---> INVERSOR CENTRAL <---



fprintf('\n\n\n<strong>=== CÁLCULOS DE DIMENSIONAMIENTO: INVERSOR CENTRAL ===</strong>\n');

fprintf('\nNúmero de módulos FV final (redondeado): ☀️ %d módulos fotovoltaicos ☀️️\n', N_modulos_final);

Voc_invcentr = Voc * 1.1;                   % (V) Voltaje en circuito abierto
Vmp_invcentr = Vmp * Factor_correccion;     % (V) Voltaje en máxima potencia
Isc_invcentr = Isc * 1.25;                  % (A) Corriente en circuito abierto

% 1. Chequeo de rango MPPT (Eficiencia)
if (Vmp_invcentr > Tension_max_registro_corriente_min && Voc_invcentr < Tension_max_registro_corriente_max)
   Check_V_MPPT_invcentr = true;
end

% 2. Cheque de intervalo de funcionamiento (Seguridad)
if (Voc > Intervalo_func_min && Voc < Intervalo_func_max)
    Check_V_Voc_invcentr = true;
end

% 3. Chequeo de Corriente Máxima
Check_I_Max_invcentr = Isc_invcentr < modulo_Isc;

% Usamos la función check_status para formatear la salida
fprintf('\n1. Compatibilidad de Potencia (Pmax): %s\n', Check_status(Check_Pmax));
fprintf('2. Rango MPPT (Vmp): %s\n', Check_status(Check_V_MPPT_invcentr));
fprintf('3. Intervalo de Operación (Voc): %s\n', Check_status(Check_V_Voc_invcentr));
fprintf('4. Corriente Máxima (Isc): %s\n', Check_status(Check_I_Max_invcentr));

% Función auxiliar para mostrar SI/NO con emojis
function Result_status = Check_status(Value)
    if Value
        Result_status = '✅ SÍ Compatible';
    else
        Result_status = '❌ NO Compatible (Revisar)';
    end
end

num_equipos = (P_FV * 1000)/Max_cont_out_P;
num_equipos_redondeado = round(num_equipos,0);

fprintf('\nNúmero de equipos calculados (decimal): %f \n', num_equipos);
fprintf('Número de equipos final (redondeado): %d ️️\n', num_equipos_redondeado);

P_req = (P_FV * 1000) * 1.2;
P_obt = N_modulos_final * Potencia_MFV_STC;

% Comprobacion de equipos necesarios con sobredimensionamiento
Check_sobredi = P_obt < P_req;

fprintf('\n%.2f < %.2f: %s\n', P_obt, P_req,Check_Status(Check_sobredi));

function Result_Status = Check_Status(value)
    if value
        Result_Status = '✅ SÍ La potencia obtenida con los datos actuales está por debajo de la requerida';
    else
        Result_Status = '❌ NO Revisar número de microinversores/paneles para ajustar la potencia obtenida';
    end
end

% CALCULO DEL BREAKER PARA PROTECCION DEL SISTEMA DE GENERACION DE ENERGIA

fprintf('\n<strong>CALCULO DEL BREAKER PARA PROTECCION DEL SISTEMA DE GENERACION DE ENERGIA</strong>')

Imax = I_max_cont * 1.25;   % (A) Corriente máxima con factor de seguridad
Breaker = Imax * 2;         % (A) Corriente mínima que necesita el breaker

fprintf(['\n\nEl breaker con valor más cercano a %.2f es de 25 y solo se necesita 1 línea para conectar los paneles ' ...
    'y el breaker'], Breaker);