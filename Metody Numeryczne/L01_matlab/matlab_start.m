% Moj pierwszy program - to komentarz, tekst po znaku %
% Program matlab_start.m
clear all; close all;    % zerowanie pamieci, usuwanie rysunkow
echo on                  % wyswietlanie linii programu na ekranie

a = 1; b = 3;  % inicjalizacja zmiennych, nie wyswietlaj wyniku (poniewaz srednik ;)
c = a+b,       % oblicz +,-,*,/,^(potega), wyswietl wynik (poniewaz przecinek ,)
d = sqrt(c),   % oblicz pierwiastek kwadratowy, wyswietl wynik (poniewaz przecinek ,)
e = a + j*b,   % liczba zespolona, j=sqrt(-1)
f = conj(e),   % sprzężenie liczby zespolonej 
whos           % wyswietlanie zawartosci pamieci

% funkcje: log (zamiast ln), log2, log10, exp, sqrt, rem(a,b)
% sin/cos/tan, asin/acos/atan, sinh/cosh/tanh, asinh/acosh/atanh