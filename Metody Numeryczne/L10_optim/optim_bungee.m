% optim_bungee.m
% Skok na bungee
clear all; close all;

global z0 m c v0 g

z0 = 100;  % wysokoœæ pocz¹tkowa [m]
m = 80;    % masa [kg]
c = 15;    % opór liniowy [kg/s]
v0 = 55;   % prêdkoœæ pocz¹tkowa [m/s]
g = 9.81;  % przyspieszenie ziemskie [m/s^2]

t = 0 : 0.01 : 13;
z   = @(t) ( z0 + m/c * (v0+(m*g)/c) * (1-exp(-(c/m)*t)) - ((m*g)/c)*t );
z1p = @(t) ( v0*exp(-(c/m)*t)-((m*g)/c)*(1-exp(-(c/m)*t)) );
z2p = @(t) ( (-(c/m)*v0-g)*exp(-(c/m)*t) );
t0 = (m/c)*log(1+(c*v0)/(m*g));

disp('FIGURES');

figure; plot(t,z(t),'b-',t0,z(t0),'r*'); grid;
xlabel('t [s]'); ylabel('z [m]'); title('z(t)'); pause

figure; plot(t,z1p(t),'b-',t0,z1p(t0),'r*'); grid;
xlabel('t [s]'); ylabel('z1p [m]'); title('z1p(t)'); pause

figure; plot(t,z2p(t),'b-',t0,z2p(t0),'r*'); grid;
xlabel('t [s]'); ylabel('z2p [m]');title('z2p(t)'); pause

disp('GOLD SEARCH');
ifigs = 1;
tstart = 1; tstop = 7; err = 0.000001; maxiter = 100; t0,
[t0est,z0est,err,iter] = goldsearch( 'fun_bungee', tstart, tstop, err, maxiter, ifigs, t)

disp('QUADRATIC SEARCH');
ifigs = 1;
t1 = 1; t2 = 2; t3 = 3; tol=10^(-4); maxiter = 25; t0,
[t0est,z0est] = quadsearch( 'fun_bungee', t1, t2, t3, tol, maxiter, ifigs, t )

disp('MATLAB fminbnd');
z0 = 100; m = 80; c = 15; v0 = 55; g = 9.81;
z = @(t) -( z0 + m/c*(v0+(m*g)/c)*(1-exp(-(c/m)*t))-((m*g)/c)*t );
[x,f] = fminbnd(z,0,8)

options = optimset('display','iter');
fminbnd(z,0,8,options)
