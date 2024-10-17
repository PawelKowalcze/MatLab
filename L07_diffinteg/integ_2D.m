% integ_2D.m
% Calkowanie 2D
clear all; close all;

sigma=1;                                             % wartosc parametru
[X, Y] = meshgrid(1:0.2:3,1:0.2:3);                  % zmiennosc argumentow x, y
p = 1/(2*pi*sigma^2)*exp(-1/2*(X.^2+Y.^2)/sigma^2);  % wartosci funkcji w punktach (x,y)
figure; surf(X,Y,p);                                 % zobacz co calkujesz
xlabel('x'); ylabel('y'); title('p(x,y)');           % opis rysunku                                  
w = 0.2/2*[1 2*ones(1,9) 1];                         % metoda trapezow 
c = w*p*w',                                          % calka 2D