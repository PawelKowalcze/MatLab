% ai_4_logreg_usterki.m

clear all; close all;

% Wczytaj dane
  load dane_usterki.txt; dane = dane_usterki; itest=1; % kontrola jakosci produkcji
% load dane_astma.txt;   dane = dane_astma;   itest=2; % diagnostyka zdrowia

  [N,M] = size( dane );  % wymiary danych: liczba przykladow, liczba cech plus 1
  X = dane(:,1:M-1);     % cechy
  y = dane(:,M);         % decyzja
  M = M-1;               % liczba cech 

  nr_alarm = find(y == 1);   % stan wadliwy
  nr_ok    = find(y == 0);   % stan poprawny

    figure
    plot( X(nr_ok,1), X(nr_ok,2), 'bs','MarkerFaceColor','g');
    hold on;
    plot( X( nr_alarm,1 ), X( nr_alarm,2 ), 'ko','MarkerFaceColor','r');
    xlabel('Cecha 1'); ylabel('Cecha 2'); grid;
    legend('dobre','zle');
    pause

% Dodanie cech "wielomianowych" typu X1^2, X2^2, ..., (X1^2)*(X2^3)
% Umozliwia uzyskanie bardziej skomplikowanych krzywych decyzyjnych
  poly_degree = 4;      % stopien wielomianu
  X = nowa_macierz_cech( X(:, 1), X(:, 2), poly_degree );

% Znalezienie optymalnych wartosci wag "g" dla zbioru uczacego
  Niter = 500;          % liczba cykli uczenia, tzw. epoch
  lambda = 1.;          % wsp. regularyzacji
  w = train_logistic_regress( X, y, lambda, Niter );

% Sprawdzenie krzywej decyzyjnej
% Wygenerowanie wartosci cech x1 (u) i x2 (v) w wezlach siatki sprawdzajacej 
  if(itest==1) x1 = linspace(-1.2, 1.2, 50); x2 = linspace(-1.2, 1.2, 50);  end
  if(itest==2) x1 = linspace(1, 4, 50);      x2 = linspace(0, 1.5, 50);     end
% Obliczamy z = sum( x .* w' ) dla kazdego punktu siatki testowej
% czyli sprawdzamy jakie wartosci zwroci funkcja kosztu dla tych danych
  z = zeros( length(x1), length(x2) );
  for i = 1 : length(x1)
      for j = 1 : length(x2)
        x = nowa_macierz_cech( x1(i), x2(j), poly_degree ); % dodanie cech wielomianowych
        z(i, j) = x * w;                                    % obliczenie wartosci funkcji 
      end
  end
% Nakladamy na poprzedni rysunek kontur dla z=0, dlatego zakres [0, 0]
  contour(x1, x2, z', [0, 0], 'LineWidth', 2);
  title(sprintf('Regularyzacja: lambda = %g', lambda));
  legend('dobre', 'zle', 'decyzja');
  hold off;
  pause

% Dodatkowy rysunek
  figure;
  subplot(121); mesh( x1, x2, z' ); grid; xlabel('Cecha 1'); ylabel('Cecha 2'); 
  title('Ksztalt funkcji regresji z=g(c1,c2)');
  subplot(122); surfc( x1, x2, z', 'FaceAlpha',0.85, 'FaceColor', 'flat' );
  grid; xlabel('Cecha 1'); ylabel('Cecha 2');
  title('Progowanie funkcji');
  hold on;
  mesh( x1, x2, zeros(size(z')) );
  hold off;