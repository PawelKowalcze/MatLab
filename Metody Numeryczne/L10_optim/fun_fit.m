% #############################    
function blad = fun_fit(params)
% #############################

global dane

%  Funkcja wykorzystywana przez program optim_nonlin_ls.m
%
%   y = c(1)*exp(-lambda(1)*x) + c(2)*exp(-lambda(2)*x)
%
%  Wejscie : parametry c(1), c(2) oraz lambda(1), lambda(2)
%  Wyjscie : blad aproksymacji danych eksperymentalnych przez
%	         aktualny zestaw parametrow lambda

   x = dane(:,1); y = dane(:,2);        % podstaw dane do zmiennych lokalnych
                                        % w programie glownym
   c(1:2) = params(1:2);                % szukane c(1) i c(2)
   lambda(1:2) = params(3:4);           % wynikowe lambda(1) i lambda(2)

   fy = c(1)*exp(-lambda(1)*x) + c(2)*exp(-lambda(2)*x);  % aktualna wartosc

   blad = std(fy-y);  % jak wartosci funkcji rozni sie od danych eksperymentalnych
                      % dla obecnych parametrow lambda i c

  % Pokaz postep w dopasowaniu parametrow funkcji do danych eksperymentalnych
  plot(x,fy,x,y,'o'); xlabel('x'); xlabel('y'); title('y=f(x)'); grid;
  xt = max(x)/2;
  yt = max(y)/2;
  text(xt,1.2*yt,['lambda = ' num2str( lambda(1) ) '    ' num2str( lambda(2) )])
  text(xt,1.1*yt,['c           = ' num2str( c(1) ) '    ' num2str( c(2) )])
  text(xt,1.0*yt,['blad      = ' num2str( blad )])
  pause
