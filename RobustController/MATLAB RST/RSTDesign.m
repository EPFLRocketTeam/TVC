clc
clear

%% Constant
g = 9.8;
m = 2;
rz = 25E-3;
Iz = m*rz*rz;
rxy = 200E-3;
Ixy = m*rxy*rxy;

%% Model - linéarisé lorsque la position est constante

A = zeros (12);
A(1:3,4:6) = eye(3);
A(10:12,7:9) = eye(3);
A(8,1) = g;
A(7,2) = -g;

Ts =  0.0082;

B = zeros(12,4);
B(4,2) = 1/Ixy;
B(5,3) = 1/Ixy;
B(6,4) = 1/Iz;

%%

Tset = 0.6; %maximum settling amplitude
zeta = 0.7; % damping ratio
omegan = 4/(zeta*Tset);

p1 = -2*exp(-zeta*omegan*Ts)*cos(omegan*Ts*sqrt(1-zeta^2));
p2 = exp(-2*zeta*omegan*Ts);
P = [1 p1 p2];
alpha = 3;
Hs = [1 -1];
Hr = ones(1);
[R, S] = poleplace(B, A, Hr, Hs, P);