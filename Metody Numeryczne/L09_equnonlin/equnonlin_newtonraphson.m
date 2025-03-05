% equnonlin_newtonraphson.m
clear all; close all; format long;

A = 4;
f  = @(x) x^2 - A;           % wzor funkcji
fp = @(x) 2*x;               % wzor jej pochodnej
x(1) = 1; x(2) = 1.1; K=10;  % punkt startowy (estymata poczatkowa), liczba iteracji
for k = 3 : K
  % x(k)=x(k-1) - f(x(k-1)) / fp(x(k-1)) ;                                 % z wzorem pochodnej
    x(k)=x(k-1) - f(x(k-1)) / ((f(x(k-1))-f(x(k-2))) / (x(k-1)-x(k-2))) ;  % z estymacja pochodnej 
end
blad = sqrt(A) - x(K), 
plot(1:K, x,'b.-', 1:K, sqrt(A)*ones(1,K),'r-'); grid; title('x(k)'); pause