% optim_analyticgrad1.m
clear all; close all;

% Bungee jump
% z(t) - funkcja wysokosci
% z1p(t), z2p(t) - jej pierwsza i druga pochodna

z0 = 100; m = 80; c = 15; v0 = 55; g = 9.81;
z = @(t) ( z0 + m/c * (v0+(m*g)/c) * (1-exp(-(c/m)*t)) - ((m*g)/c)*t );
z1p = @(t) ( v0*exp(-(c/m)*t)-((m*g)/c)*(1-exp(-(c/m)*t)) );
z2p = @(t) ( (-(c/m)*v0-g)*exp(-(c/m)*t) );
t0 = (m/c)*log(1+(c*v0)/(m*g));

% Znajdz sam maksimum funkcji z(t) ...