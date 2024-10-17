% integ_erf_compare.m
% Porownanie roznych metod podczas calkowania funkcji erf()
clear all; close all;

c_erf = erf( 3/sqrt(2) ),                    % wartosc obliczona przez Matlaba
f = inline( '1/sqrt(2*pi)*exp(-x.^2/2)' );   % calkowana funkcja
h = 0.6;                                     % odleglosc pomiedzy wezlami

x = -3 : h : 3;                              % metoda trapezow                                      
w = ones(size(x)); w(2:1:end-1) = 2;         % wagi
c_trapez = h/2*w*f(x)',                      % suma iloczynow (kwadratur)

x=-3 : h : 3; N = length(x);                 % metoda Simpsona 1/3                              
w = ones(1,N); w(3:2:N-2)=2; w(2:2:N-1)=4;   % wagi
c_simpson13 = h/3*w*f(x)',                   % suma iloczynow (kwadratur)

x=[-sqrt(3/5) 0 sqrt(3/5)]; w=1/9*[5 8 5];   % metoda Gaussa 3 wezly
c_gauss3 = 3*w*f(3*x)',                      % suma iloczynow (kwadratur)  

x=[-sqrt(3/5) 0 sqrt(3/5)]; w=1/9*[5 8 5];   % metoda Gaussa 3*3 wezly 
c_gauss33 =  w*f(x-2)'+w*f(x)'+w*f(x+2)',    % suma trzech sum    

[c_quad,i] = quad(f,-3,3),    % metoda adaptacyjna Simpsona + Newtona-Cotesa

[c_quadl,i] = quadl(f,-3,3),  % metoda adaptacyjna Gaussa-Lagrange'a                  

format longE                  % porownanie bledow
[ abs(c_trapez-c_erf); ...
  abs(c_simpson13-c_erf); ...
  abs(c_gauss3-c_erf); ...
  abs(c_gauss33-c_erf); ...
  abs(c_quad-c_erf); ...
  abs(c_quadl-c_erf) ]