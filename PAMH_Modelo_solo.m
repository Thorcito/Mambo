clc;
clear;
close all;

%% Modelo
%deltaT = Tiempo(2)-Tiempo(1);
%Pendulo = iddata([ANGULO], [ESTIMULO], deltaT);
%Pendulo.inputname = {'Estimulo'};
%Pendulo.outputname = {'Angulo'};

%ident;
%Cargar el archivo MotorCD.sid

s = tf ('s');
FuncTrans_P2Z0 = (5.341)/(s^2 + 0.2325*s + 15.22);

ModeloAngulo = zpk(FuncTrans_P2Z0);
%ModeloAngulo = P(1,1);

y1 = lsim(ModeloAngulo,ESTIMULO,Tiempo);
plot(Tiempo, ESTIMULO, Tiempo, ANGULO, Tiempo, y1);
grid;
title('Verificacion de la respuesta del modelo del angulo');
xlabel('Tiempo [s]');
ylabel('Angulo');
legend('Estimulo','Angulo','Modelo');

%M1Var = ss(FuncTrans_P1Z0);
PVar = ss(FuncTrans_P2Z0);