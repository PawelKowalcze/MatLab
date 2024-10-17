% equnonlin_invmuller.m
clear all; close all; format long;

A = 4;
f  = @(x) x^2 - A;                 % wzor funkcji
x(1)=1; x(2)=1.1; x(3)=1.2; K=10;  % punkty startowe (estymata poczatkowa), liczba iteracji
for k = 3 : K-1
    k
    x(k+1) = f(x(k-1))*f(x(k-2)) / ( (f(x(k))-f(x(k-1)))*(f(x(k))-f(x(k-2))) ) *x(k) + ...
             f(x(k))*f(x(k-2)) / ( (f(x(k-1))-f(x(k)))*(f(x(k-1))-f(x(k-2))) ) *x(k-1) + ...
             f(x(k))*f(x(k-1)) / ( (f(x(k-2))-f(x(k)))*(f(x(k-2))-f(x(k-1))) ) *x(k-2);
end
blad = sqrt(A) - x(K), 
plot(1:K, x,'b.-', 1:K, sqrt(A)*ones(1,K),'r-'); grid; title('x(k)'); pause