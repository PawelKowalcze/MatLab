
function blad = fun_fit81(lambda)

global dane

%  Funkcja wykorzystywana przez cw_81.m
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

  x = dane(:,1); y = dane(:,2);         % podstaw dane do zmiennych lokalnych
                                        % w programie glownym
  A = zeros(length(x),length(lambda));  % utworz macierz A i ja wstepnie wyzeruj
                                        % wierszy tyle ile danych,
                                        % kolumn tyle ile lambda
                                        %
  for j = 1:size(lambda)                % dla kaxdego x i kazdego lambda
    A(:,j) = exp(-lambda(j)*x);         % oblicz wartosci macierzy A,
  end                                   % takiej ze y = A * c
                                        %
  c = A \ y;         % oblicz wektor optymalnych parametrow c
                     % minimalizujacych blad sredniokwadrat
                     %
  fy = A * c;        % oblicz wartosci funkcji fy dla tego c
                     %
  blad = std(fy-y);  % jak wartosci funkcji roznia sie od
                     % danych eksperymentalnych
                     % obecnych parametrow lambda i c

  % Pokaz postep w dopasowaniu parametrow funkcji do danych eksperymentalnych

  plot(x,fy,x,y,'o'), grid
  xt = max(x)/2;
  yt = max(y)/2;
  text(xt,1.2*yt,['lambda = ' num2str( lambda(1) ) '  ' num2str( lambda(2) )])
  text(xt,1.1*yt,['c      = ' num2str( c(1) ) '  ' num2str( c(2) )])
  text(xt,1.0*yt,['blad   = ' num2str( blad )])
  pause

