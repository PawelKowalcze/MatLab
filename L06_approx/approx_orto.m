% approx_orto.m
clear all; close all;

N=100;                % Liczba definiowanych punktow czasowych
M=5;                  % Liczba sinusoid uzytych do aproksymacji

x = [0 : 2*pi/N : 2*pi*(N-1)/N]';   % Wektor pionowy [rad]: 0 : krok : maksimum
y = sawtooth(x);                    % Zadany przebieg piloksztaltny, od -1 do 1
figure; plot( y ); pause            % Sygnal aproksymowany

X = sqrt(2/N) * sin(x*[1:M]) ;      % Macierz z ortogonalnymi sinusami w kolumnach
figure; plot( X(:,5)' ); pause      % Przykladowo 5-ta kolumna

a = X'*y;                           % Wynik transformacji, szukany wektor wspolczynnikow 
figure; plot(x,y,'r.',x,X*a); grid; % Funkcja oryginalna i jej aproksymata
