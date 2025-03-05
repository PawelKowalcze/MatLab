% integ_circle.m
clear all; close all; format long;

Methods={                % nazwa metody
'trapezy1',
'simpson2',
'simpson3',
'bool4'
};
Ns=2:5;                  % liczba wezlow
W={                      % wagi wezlow:
[1 1]/2,                 % trapezy 1
[1 4 1]/3,               % Simpson 2
[1 3 3 1]*3/8,           % Simpson 3
[7 32 12 32 7]*2/45      % Boole 4
};
alf = 0 : (pi/2)/200 : pi/2; c=cos(alf); s=sin(alf);
for i = 1:length(Ns)            % PETLA - wybor metody
    metoda = Methods{i}         % nazwa metody 
    N = Ns(i);                  % liczba wezlow
    h = 1/(N-1);                % odleglosc pomiedzy wezlami
    x = 0 : h : 1;              % kolejne wartosci x
    y = sqrt(1-x.^2);           % kolejnosci wartosci y (x^2 + y^2 = 1)
    PI = sum( W{i} .* y )*h*4   % suma kwadratur, czyli calka
    figure; plot(c,s,'b-',x,y,'ro'); title(metoda = Methods{i}); axis square; grid;
end                             