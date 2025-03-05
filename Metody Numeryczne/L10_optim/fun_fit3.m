
function blad = fun_fit82(params)

global dane

%  Funkcja wykorzystywana przez cw_82.m
%  Ma ona nastepujaca postac (wywolywana z N=2):
%
%   y = c(1)*exp(-lambda(1)*x) + ... + c(N)*exp(-lambda(N)*x)
%
%  oraz posiada N parametrow liniowych c(i) i nieliniowych lambda(i)
%
%  Wejscie : zestaw parametrow lambda
%  Wyjscie : blad aproksymacji danych eksperymentalnych przez
%	          aktualny zestaw parametrow lambda
%
%  parametry c(i) sa wyznaczane na podstawie lambda i danych doswiadczalnych

   x = dane(:,1); y = dane(:,2);        % podstaw dane do zmiennych lokalnych
                                        % w programie glownym
   c(1:2) = params(1:2);                % szukane c(1) i c(2)
   lambda(1:2) = params(3:4);           % wynikowe lambda(1) i lambda(2)

   fy = c(1)*exp(-lambda(1)*x) + c(2)*exp(-lambda(2)*x);

   blad = std(fy-y);  % jak wartosci funkcji roznia sie od
                      % danych eksperymentalnych
                      % obecnych parametrow lambda i c

  % Pokaz postep w dopasowaniu parametrow funkcji do danych eksperymentalnych

  plot(x,fy,x,y,'o'), grid
  xt = max(x)/2;
  yt = max(y)/2;
  text(xt,1.2*yt,['lambda = ' num2str( lambda(1) ) '    ' num2str( lambda(2) )])
  text(xt,1.1*yt,['c      = ' num2str( c(1) ) '    ' num2str( c(2) )])
  text(xt,1.0*yt,['blad   = ' num2str( blad )])
  pause
