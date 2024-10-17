function blad = fun_fit1( params )

global dane

%  Funkcja wykorzystywana przez optim_curvefit1.m
%  Ma ona nastepujaca postac :
%
%   y = a*x^2 + b
%
%  Wejscie : parametry a i b
%  Wyjscie : blad aproksymacji danych eksperymentalnych przez funkcje

  a = params(1); b = params(2);       % szukane parametry
  x = dane(:,1); y = dane(:,2);       % dane z programu glownego

  fy = a * x.^2 + b;                  % oblicz wartosci funkcji f(x)
                                      % dla aktualnych parametrow a i b
  blad = std( fy-y );                 % jak wartosci funkcji roznia sie od
                                      % danych eksperymentalnych

  % Pokaz postep w dopasowaniu parametrow funkcji do danych eksperymentalnych

  plot(x,fy,x,y,'o'), grid
  xt = 0;
  yt = 3/4*max(y);
  text( xt, 1.2*yt, ['a    = ' num2str( a ) ] )
  text( xt, 1.1*yt, ['b    = ' num2str( b ) ] )
  text( xt, 1.0*yt, ['blad = ' num2str( blad ) ] )
  pause
  