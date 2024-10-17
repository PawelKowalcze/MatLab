% ai_5_logreg_cyfry.m
% Rozpoznawanie cyfr z uzyciem techniki "machine learning"

clear all; close all;

% Wczytanie danych (obrazow)
  load cyfry.mat       % 10 razy po 500 obrazkow 20x20 pikseli na jedna cyfre  
                       % macierz X: 5000 wierszy po 400 liczb w wierszu
  N_klas = 10;         % liczba testowanych cyfr 0,1,2,...,9
  N_wzorcow = 500;     % liczba przykladow/wzorcow dla kazdej klasy/cyfry 
  N_x = 20;            % liczba pikseli kazdego obrazu-wzorca w poziomie 
  N_y = 20;            % liczba pikseli kazdego obrazu-wzorca w pionie

  N_przykladow = N_klas *N_wzorcow;  % liczba wszystkich obrazow-wzorcow
  N_cech  = N_x * N_y;               % liczba wszystkich pikseli pojedynczego obrazu

  colormap(gray);      

% Pokaz wybrane obrazy wzorcow
  n1st = 10;                      % od 1 do N_wzorcow
  i = 1; imgsum = zeros( 3*N_y, 3*N_x );
  j = 1;
  nrchoice = [ 500+n1st : 500 : N_przykladow ] 
  figure;
  for iter = 1 : 9
      nr = nrchoice( iter );
      img = X( nr, 1 : N_cech );          % cechy to kolejne piksele
      img = reshape( img, N_y, N_x );
      imagesc( img ); pause(0.5)
      imgsum( i : i+(N_x-1) , j : j + (N_y-1) ) = img; 
      j = j + N_y;
      if( j == 3*N_y+1) j = 1; i = i + N_x; end
  end
  figure; imagesc( imgsum ); axis square; pause
  figure; plot(y); xlabel('nr przykladu'); ylabel('nr klasy'); grid; title('Ch-ka danych'); pause

  X =  [ ones(N_przykladow, 1) X ];       % dodanie 1 dla w0

% Znalezienie optymalnych wartości wag "w" na podstawie zbioru uczącego dla kazdej klasy
  N_iter_fmin = 50;                       % liczba iteracji proceduru minimalizacyjnej
  lambda = 0.01;                          % wspolczynnk regularyzacji podczas minimalizacji 
  w_all = zeros( N_klas, 1 + N_cech);     % w0, w1, w2, ..., wP - poczatkowe wagi pikseli

  options = optimset('GradObj', 'on', 'MaxIter', 50 );   % dla funkcji fmincg()
  for nr_klasy = 1 : N_klas               % powtorz dla kazdej klasy, cyfra 0 to klasa 10 
      y_klasy = (y == nr_klasy);          % ustaw 1 w wektorze y-klasa tylko dla wybranej klasy
      w_init = zeros(1 + N_cech, 1);      % inicjalizacja wag
      gradient_function = @(t) optim_callback( X, y_klasy, t, lambda );
      w = fmincg( gradient_function, w_init, options);
      w_all( nr_klasy, :) = w'; 
      plot(y_klasy); title('Sprawdzona klasa'); disp('Nacisnij cokolwiek ...'); pause
  end

% Rozpoznawanie cyfr ze zbioru uczacego  
  hipotezy = sigmoid( X * w_all' );             % wartosci funkcji decyzyjnej: 5000x10
  [ wartosc, indeks ] = max( hipotezy, [], 2);  % indeksy maksimow dla kazdego przykladu
  fprintf('\nAccuracy: %f\n', mean( double( indeks == y )) * 100);

% #######################################################################
% #########################################################################
% #########################################################################
function [cost, gradients] = optim_callback( X, y, w, lambda )
  N = length( y );                                         % liczba przykladow
  y_pred = sigmoid( X * w );                               % predykcja/prognoza/hipoteza y
  cost = cost_function( X, y, y_pred, w, lambda, N );      % obliczenie funkcji kosztu
  gradients = gradient_step( X, y, y_pred, w, lambda, N ); % obliczenie gradientów dla "w"
end
% #########################################################################
function [cost] = cost_function( X, y, y_pred, w, lambda, N )
  regular = lambda/(2*N) * sum( w(2:end,1).^2 );                     % parametr regularyzacji
  cost = -(1/N) * (y'*log(y_pred) + (1-y)'*log(1-y_pred)) + regular; % funkcja kosztu/bledu
end
% #########################################################################
function [gradients] = gradient_step( X, y, y_pred, w, lambda, N )
  regular = (lambda/N) * w;                                   % parametr regularyzacji 
  gradients    = (1/N) * (X'      * (y_pred - y)) + regular;  % regularyzacja dla wszystkich w  
  gradients(1) = (1/N) * (X(:,1)' * (y_pred - y));            % oprocz w0
end  
% #########################################################################
function y = sigmoid( x )
  y = 1 ./ (1 + exp(-x));
end
