% optim_leastmoduli.m
% Kryterium dopasowania typu least-moduli (najmniejsza suma wartosci bezwzglednych)
clear all; close all;

i = [0.0 0.2 0.4 0.6 0.8 1.0];    % zmierzony prad zarowki
u = [0 30 60 110 175 270];        % zmierzone napiecie zarowki

a = fminsearch('zar_kryterium', [0 0 0],[],i,u),  % kryterium, punkt start, pomiar i,u 
um = zar_model(a,i);                              % napiecia z modelu

figure;
plot(i,um,'-',i,u,'*'); grid;               % porownanie: 
xlabel('i'); ylabel('u');                   % model um=f(i), rzeczywistosc (i,u)
title('u=f(i)=a_3 i^3+a_2 i^2+a_1 i^1');    %