% ai_3_linreg_kwatera_wielomian.m
% Przyklad aproksymacji funkcji wielomianem wyzszego rzedu, a nie linia prosta.
% Jeden argument: wplyw tylko powierzchni mieszkania (x) na jego koszt (y):
% y =  w0 + w1*x^1 + w2*x^2 + w3*x^3 + wK*x^K

  clear all; close all;
  load dane_kwatera.txt; dane = dane_kwatera; clear dane_kwatera
  K = 6;                      % maksymalny stopien wielomianu aproks., min 1
  [N,M] = size(dane),         % N = liczba zestawow danych, M = liczba zmiennych
  x     = dane(:,1);          % kolumna 1 danych = powierzchnia w m^2
  y     = dane(:,3);          % kolumna 3 danych = koszt wynajmu w zlotych

    figure;
    plot( x, y,'bo'); grid;
    xlabel('Powierzchnia [metry^2]');
    ylabel('Koszt wynajmu [zlote]');
    title('y = funkcja( x )');
    axis([10,120,0,15000])
    hold on;

  xi = (10 : 1 : 120)';        % argumenty funkcji gesto sprobkowane
  X = ones( N, 1 );            % wartosci pierwszej kolumny macierzy Vandermonde'a
  Xi = ones( length(xi), 1 );  % j.w. tylko dla gestego probkowania
  for k = 1 : K                % dla kolejnych stopni wielomianu
      X = [ X x.^k ];          % macierz Vandermonde'a wyzszego stopnia
      w = inv(X'*X)*X'*y,      % macierzowe obliczenie wsp. wagowych wielomianu

      Xi = [ Xi xi.^k ];       % macierz Vandermonde'a wyzszego stopnia dla aproksymscji
      yi = Xi * w;             % obliczenie funkcji aproksymujacej
      plot( xi, yi );          % dodanie do rysunku funkcji aproksymujacej wyzszego stopnia
      hold on;                 % 
      pause
  end