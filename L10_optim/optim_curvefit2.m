% optim_curvefit2.m
% Dopasowanie funkcji do danych funkcji, ale trudniejszej
% ni¿ w przykladzie optim_curvefit1.m
clear all; close all;

  global dane            % zmienna globalna - tzn. widziana z innych *.m zbiorow

  dane = ...             % pary punktow (x,y), otrzymane doswiadczalnie
  [ 0.0000    5.8955     % np. podczas laboratorium z fizyki
    0.1000    3.5639     % pierwsza kolumna argument x
    0.2000    2.5173     % druga kolumna wartosc y
    0.3000    1.9790
    0.4000    1.8990
    0.5000    1.3938
    0.6000    1.1359
    0.7000    1.0096
    0.8000    1.0343
    0.9000    0.8435
    1.0000    0.6856
    1.1000    0.6100
    1.2000    0.5392
    1.3000    0.3946
    1.4000    0.3903
    1.5000    0.5474
    1.6000    0.3459
    1.7000    0.1370
    1.8000    0.2211
    1.9000    0.1704
    2.0000    0.2636 ];

    x = dane(:,1);               % pobranie wektora argumentow x
    y = dane(:,2);               % pobranie wektora wartosci funkcji y
    plot(x,y,'ro')                % wykres y w funkcji x, czerwone "o"
    title('Dane doswiadczalne')  % tytul
    grid                         % krata
    pause                        % pauza
    clc                          % czyszczenie ekranu tekstowego

    %  Z teorii wynika, ze dane zjawisko opisuje teoretyczna zaleznosc:
    %
    %	  y = f( x ) = c(1) * exp(-lambda(1)*x) + c(2) * exp(-lambda(2)*x)
    %
    %  Powyzsza funkcja ma dwa parametry liniowe: c(1) i c(2)
    %  oraz dwa parametry nieliniowe: lambda(1) i lambda(2)
    %
    %  Chcemy wyznaczyc takie wartosci tych parametrow, tak aby funkcja y=f(x)
    %  byla najlepiej dopasowana do punktow eksperymentalnych (x,y)

    lambda = [1 0]';             % startowe wartosci lambda(1) i (2)
    toler  = 0.1;                % wymagany blad
    opt = optimset( 'TolX', toler ); 

    blad = fminsearch('fun_fit2', lambda, opt);  % procedura minimalizacyjna
	                                         % naciskaj enter
    lambda = blad                            % wynikowe lambda(1) i (2)

    A = zeros(length(x),length(lambda));     % obliczenia jak w fun_fit.m
    for j = 1:size(lambda)                   % dla ka¿dego x i kazdego lambda
      A(:,j) = exp(-lambda(j)*x);            %
    end                                      %
    c = A \ y                                %
    fy = A * c;                              %
    blad = std(fy-y)                         %

