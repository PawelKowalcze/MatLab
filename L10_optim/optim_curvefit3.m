% optim_curvefit3.m
% Dopasowanie funkcji do danych funkcji, analogicznie jak w optim_curvefit2.m tylko trudniej
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
    plot(x,y,'ro')               % wykres y w funkcji x, czerwone "o"
    title('Dane doswiadczalne')  % tytul
    grid                         % krata
    pause                        % pauza
    clc                          % czyszczenie ekranu tekstowego

    %  Z teorii wynika, ze dane zjawisko opisuje teoretyczna zaleznosc:
    %
    %	  y = f( x ) = c(1) * exp(-lambda(1)*x) + c(2) * exp(-lambda(2)*x)
    %
    %  Powyzsza funkcja ma dwa parametry liniowe: c(1) i c(2)
    %  oraz dwa parametry nieliniowe: lambda(1) i lambda(2).
    %  Chcemy wyznaczyc takie wartosci tych parametrow, tak aby funkcja y=f(x)
    %  byla najlepiej dopasowana do punktow eksperymentalnych (x,y).

    params = [ 3.5, 2.5, 12, 1 ]; % punkt startowy [ c(1), c(2), lam(1), lam(2) ]

  % c(1) = 2.998787301736222, c(2)=2.896688863655001
  % labda(1) = 10.606681005172833, lambda(2) = 1.404754349489554
    toler  = 0.1;                % wymagany blad
    opt = optimset( 'TolX', toler ); 

    blad = fminsearch('fun_fit3', params, opt );  % procedura minimalizacyjna
	                                               % naciskaj enter
    c(1:2) = blad(1:2),                            % wynikowe c(1) i (2)
    lambda(1:2) = blad(3:4),                       % wynikowe lambda(1) i (2)

    fy = c(1)*exp(-lambda(1)*x) + c(2)*exp(-lambda(2)*x);  % wartości funkcji z modelu
    blad = std(fy-y)                                       % blad: model - rzeczywistosc
