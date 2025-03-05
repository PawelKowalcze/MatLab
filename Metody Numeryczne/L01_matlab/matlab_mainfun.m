% Program matlab_mainfun.m
% Program glowny wywolujacy funkcje matlab_fun() 
clear all; close all;

a=1; b=3;                 % pojedyncze zmienne
u=(1:3)'; v=(3:-1:1);     % wektor pionowy u=[1;2;3] i poziomy v=[3,2,1] 
A=reshape(1:9,3,3);       % macierz A o wymiarach 3x3, w kolumnach liczby od 1 do 9 
[x,y,z] = matlab_fun(a,b,u,v,A),        % wywolanie funkcji

funName = @(x,y) a*x+b*y; % funkcja typu "anonim", argumenty (x,y), stale (a,b)
wynik = funName(0.1,0.2), % oblicz dla x=0.1, y=0.2

%##########################################################################
function [wy1,wy2,wy3] = matlab_fun(we1,we2,we3,we4,we5)
% opis funkcji wyswietlany przez komende "help matlab_fun"
% "Wielki Brat" wszystko widzi i pamieta

wy1 = we1+we2;      % suma dwoch skalarow
wy2 = we3*we4;      % iloczyn wektora pionowego i poziomego
wy3 = we5*we3;      % iloczyn macierzy i wektora pionowego

end