% optim_curvefit1.m
% Wyznaczanie parametrow znanej funkcji,
% w celu jej jak najlepszego dopasowania do danych doswiadczalnych.
clear all; close all;

  global dane	      % zmienna globalna - tzn. widziana z innych *.m zbiorow

  dane = ...	      % pary punktow (x,y) otrzymanych doswiadczalnie
  [ -5	  25.5        % np. podczas laboratorium z fizyki
    -4	  15.2        % pierwsza kolumna to argument x
    -3	   8.5        % zas druga, to wartosc y
    -2	   4.3        % jest to zaszumiona funkcja postaci y = a*x^2 + b
    -1	   0.8
     0	   0.0
     1	   0.9
     2	   4.1
     3	   8.7
     4	  15.7
     5	  24.9	];

    x = dane(:,1);                % pobranie wektora argumentow x
    y = dane(:,2);                % pobranie wektora wartosci funkcji y
    plot(x,y,'ro')                % wykres y w funkcji x - czerwone "o"
    title('Dane doswiadczalne')   % tytul
    grid                          % siatka
    pause                         % pauza
    clc                           % czyszczenie ekranu tekstowego

    %  Zalozmy, ze zjawisko opisuje zaleznosc
    %
    %	  y = f(x;a,b) = a*x^2 + b
    %
    %  Juz dwie pary punktow (x1,y1) (x2,y2) wystarczaja, aby obliczyc a i b.
    %  Ale poniewaz dane eksperymentalne sa zaszumione,
    %  przeprowadza sie wiecej pomiarow i stara sie znalezc takie wartosci
    %  a i b, aby blad
    %
    %                       1     do M
    %	      blad = SQRT ( - * S U M A [ y - f(x;a,b) ]^2 )
    %                       M    od m=1
    %
    %  byl jak najmniejszy, tzn. aby funkcja byla "jak najlepiej"
    %  dopasowana do danych doswiadczalnych

    params = [1 0]';	             % startowe wartosci a i b
    toler  = 0.05;		             % wymagany blad
    opt = optimset( 'TolX', toler ); 

    blad = fminsearch('fun_fit1', params, opt ); % procedura minimalizacyjna
	                                             % naciskaj enter
    a = blad( 1 )                    % wynikowe a
    b = blad( 2 )                    % wynikowe b

    fy = a * x.^2 + b;               % oblicz wartosci funkcji f(x)
	                                 % dla koncowych parametrow a i b
    blad = std( fy-y )               % koncowy blad
    