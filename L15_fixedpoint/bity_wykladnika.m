% bity_wykladnika.m
clear all; close all;

if(0) % Metoda #1
  x=realmin; n=0;         % x = wartosc najmniejsza, inicjalizacja licznika bitow
  num2bitstr( x ); pause  % pokaz bity
  while( x < realmax )    % jesli x mniejsze od wartosci najwiekszej 
     n=n+1, x=2*x;        % to zwieksz licznik, pomnoz x przez dwa = zwieksz wykladnik o 1
     num2bitstr( x );     % pokaz bity
     pause                % analizuj je
  end                     % eksponenta=[   1]-1023=-1022  <--   1 zwiazane z realmin
  n=n+2                   % eksponenta=[2047]-1023=+1024  <--2047 zwiazane z realmax   
  nbits = log2(n),        %                         2046
                          %                        +   2
end                       %                         2048

if(1) % Metoda #2: x=1, mnozenie razy 2
  x=1, n=0,                   % inicjalizacja    
  num2bitstr( x ); pause      % reprezentacja bitowa
  while(2*x > x)              % czy widac mnozenie przez 2; jesli tak, to 
     n=n+1, x=2*x,            % zwieksz wykladnik o 1, pomnoz *2,  
     num2bitstr( x );         % zobacz zmiane bitow reprezentacji
     pause                    % zobacz zmiane bitow reprezentacji
  end                         %
  nbits = log2(n) + 1,        % +1 - potegi dodatnie i ujemne
end                           %

if(0) % Metoda #3: x=1, dzielenie przez 2
  x=1; n=1, bity_mantysy=52;  % inicjalizacja    
  num2bitstr( x ); pause      % zobacz reprezentacje bitowa
  while(x/2 < x)              % czy widac dzielenie przez 2 
     n=n+1, x=x/2,            % /2, zwiekszenie wykladnika o 1 
     num2bitstr( x );         % zobacz zmiane bitow reprezentacji
     pause                    % przeanalizuj ja
  end                         %
  n = n - bity_mantysy,       % odejmij liczbe bitow mantysy         
  nbits = log2(n) + 1,        % +1 - potegi dodatnie i ujemne
end                           %
