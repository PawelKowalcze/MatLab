% Program matlab_control.m
clear all; close all;     % zerowanie pamieci, usuwanie rysunkow

% Petla FOR, warunek IF
M=3; N=5;                 % inicjalizacja wymiarów wektora/macierzy
for m=1:M                 % początek pętli po "m"
    x(1,m)=m;             % m-ty element poziomego wektora M-elementowego 
    for n=1:N                   % początek pętli po "n" (m-ty wiersz, n-ta kolumna)
        if(m<n)      A(m,n)=2;  % jeśli warunek jest spelniony to podstaw 2 
        elseif(m==n) A(m,n)=1;  % jeśli warunek jest spelniony to podstaw 1
        else         A(m,n)=0;  % w przeciwnym przypadku podstaw 0
        end                     % koniec warunku (m<n)
    end                         % koniec petli po "n" 
end                       % koniec petli po "m"
x, A,                     % pokaz wektor i macierz
b = x*A,                  % pomnoz wektor (1,M) przez macierz (M,N)

% Petla WHILE
x = 0 : 0.1 : 0.5;         % wartości elementow wektora: od-krok-do
xmean = sum(x)/length(x);  % oblicz wartosc srednia, inaczej mean(x) 
nr = 1;                    % nr - numer elementu, na poczatku rowny 1
while( x(nr) < xmean )     % jesli wartosc x(n) jest mniejsza od sredniej,
   nr = nr + 1;            % to zwieksz numer elementu
end                        % oraz po raz kolejny sprawdz warunek
x, xmean, ostatni = nr-1,  % pokaz numer ostatniego elementy spelniajacego warunek

% Warunek SWITCH
opcja = 'tAk';             % 'tak', 'nie', 'cokolwiek'
switch( lower(opcja) )
    case 'tak', disp('Wybrano opcje: TAK');
    case 'nie', disp('Wybrano opcje: NIE');
    otherwise,  disp('Niepoprawna opcja');
end
liczba = 1;               % 1, 2, cokolwiek
switch( liczba )
    case 1,    disp('Liczba: 1');
    case 2,    disp('Liczba: 2');
    otherwise, disp('Niepoprawna liczba');
end
