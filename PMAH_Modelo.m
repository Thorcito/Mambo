clc;
close all;


%Modelo
deltaT = Tiempo(2)-Tiempo(1);
Pendulo = iddata([ANGULO], [ESTIMULO], deltaT);
Pendulo.inputname = {'Estimulo'};
Pendulo.outputname = {'Angulo'};

ident;
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

%Control

sisotool ('rlocus', ModeloAngulo);
eig(ModeloAngulo); %Para ver polos y luego añadir un cero complejo y cancelar los polos en el sisotool.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%definimos las matrices A, B, M y sus respectivas con sombrerito 

A = [];
B = [];
M = [];
As = [];
Bs = [];
Ms = [Bs As*Bs As^2*Bs];

%%para comprobar el rango usamos rank(?)

s = tf('s');

Ps = [-4+3i -4-3i 10];

polia = s^3 + 18*s^2 + 105*s + 250;

fia = As^3 + 18*As^2 + 105*As + 250*eye(3);

Ks = [0 0 1]*inv(Ms)*fia;

%%Forma automatica

help acker;

Ks2 = acker(As,Bs,Ps); %%USAR ESTE EN EL LAB 

%%Forma automatica LQR (siempre da un sistema estable)

help lqr;

[Ks3 S E] = lqr(As,Bs,eye(3),1); %%Se prueban si los polos obtenidos resulven el sistema
[Ks3 S E] = lqr(As,Bs,diag([5,5,1]),1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIN TEORIA
s = tf ('s');

FuncTrans_P2Z0 = (5.341)/(s^2 + 0.2325*s + 15.22);

sysp = canon(FuncTrans_P2Z0,'companion');

Afcc =sysp.a';
Bfcc =sysp.c';
Cfcc = sysp.b';

modelofcc = ss(Afcc,Bfcc,Cfcc,00); %Espacio de Estados

As = [Afcc [0;0];-Cfcc 0];
Bs = [Bfcc;0];

sisotool(FuncTrans_P2Z0) %5s >3%

%se obtienen los polos -1+-0.5i y uno real 5 veces a los complejos

Ps = [-1+0.5i -1-0.5i -5];

%Se prueba controlabilidad

Mx = [Afcc Bfcc;-Cfcc 0];

rank(Mx);
det(Mx);
inv(Mx);

Ks = acker(As,Bs,Ps);
K = Ks(:,1:2);
Ki = -Ks(3);

simulink; %Se introducen K, Ki, Afcc, Bfcc, Cfcc


