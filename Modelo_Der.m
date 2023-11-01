%% Modelo
deltaT = tiempo(2)-tiempo(1);
Motor_Der = iddata([velD], [pwm], deltaT);
Motor_Der.inputname = {'Entrada'};
Motor_Der.outputname = {'Salida Derecha'};
Motor_Izq = iddata([velI], [pwm], deltaT);
Motor_Izq.inputname = {'Entrada'};
Motor_Izq.outputname = {'Salida Izquierda'};
%ident

s = tf ('s');
%MOTOR DERECHO
Kp_der = 2.138;
Tp1_der = 7442.8;
Tp2_der = 0.40836;
Tp3_der = 29253;
Tz_der = 10313;
FuncTrans_P3IZ_DER = Kp_der * ((1+Tz_der*s)/(s*(1+Tp1_der*s)*(1+Tp2_der*s)*(1+Tp3_der*s)));

%MOTOR IZQUIERDO
Kp_izq = -2.1319;
Tp1_izq = 10000;
Tp2_izq = 4931.9;
Tp3_izq = 5.9888;
Tz_izq = 26.129;
FuncTrans_P3IZ_IZQ = Kp_izq * ((1+Tz_izq*s)/(s*(1+Tp1_izq*s)*(1+Tp2_izq*s)*(1+Tp3_izq*s)));

ModeloVelocidadDer = zpk(FuncTrans_P3IZ_DER);
%ModeloAngulo = P(1,1);

y1 = lsim(ModeloVelocidadDer,pwm,tiempo);
plot(tiempo, pwm, tiempo, velD, tiempo, y1);
grid;
title('Verificacion de la respuesta del modelo del angulo');
xlabel('Tiempo [s]');
ylabel('Velocidad');
legend('Entrada','Velocidad','Modelo');

%M1Var = ss(FuncTrans_P1Z0);

