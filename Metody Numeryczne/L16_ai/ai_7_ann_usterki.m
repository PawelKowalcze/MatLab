% ai_7_ann_usterki.m
% Rozpoznawanie dwóch stanów 1/0 za pomocą dwch cech - badanie backpropagation

  clear all; close all;

% Wczytaj dane
  load dane_usterki.txt; dane = dane_usterki; itest=1; % kontrola jakosci produkcji
% load dane_astma.txt;   dane = dane_astma;   itest=2; % diagnostyka zdrowia
  

  [ L_przykladow, M ] = size(dane);  % wymiary danych: liczba przykladow, liczba cech plus 1
  L_klas = 2;            % liczba testowanych klas: 0. 1
  L_cech = M-1;          % liczba cech 
  X = dane(:,1:M-1);     % cechy
  y = dane(:,M) + 1;     % decyzja: 0 = stan poprawny, 1 = stan wadliwy

  nr_ok    = find(y == 1);   % stan poprawny
  nr_alarm = find(y == 2);   % stan wadliwy

    figure
    plot( X(nr_ok,1), X(nr_ok,2), 'bs','MarkerFaceColor','g');
    hold on;
    plot( X( nr_alarm,1 ), X( nr_alarm,2 ), 'ko','MarkerFaceColor','r');
    xlabel('Cecha 1'); ylabel('Cecha 2'); grid;
    legend('dobre','zle');
    pause

% Trenowanie sztucznej sieci neuronowej
  max_iter = 40;          % liczba iteracji procedury optymalizacyjnej/minimalizacyjnej
  lambda = 0.01;          % wspolczynnk regularyzacji uzyty podczas minimalizacji
  wagi_zakres = 0.12;     % zakres zmiennosci podczas inicjalizacji wsp. wagowych
  param_warstw = [        % wartosci parametrow sieci
      L_cech,             % liczba wejsc (liczba cech)
      5,                  % liczba neuronow w pierwszej warstwie ukrytej
    % 15,                 % liczba neuronow w drugiej warstwie ukrytej
      L_klas              % liczba neuronow w warstwie wyjsciowej (liczba klas, u nas 1/0)
  ];
  Wagi_macierze = ann_wagi_init( param_warstw, wagi_zakres );  % inicjalizacja wag
  Wagi_wektor   = ann_wagi_macierze2wektor( Wagi_macierze );   % macierze --> wektor
  optim_opcje   = optimset('MaxIter', max_iter );              % parametry optymalizacji
  uchwyt_funkcji = @(p) ann_koszt_gradient(p, param_warstw, X, y, lambda );    % uchwyt
  [ Wagi_wektor, koszt ] = fmincg( uchwyt_funkcji, Wagi_wektor, optim_opcje ); % optymal.
  Wagi_macierze = ann_wagi_wektor2macierze( Wagi_wektor, param_warstw );       % wynik

% Rozpoznawanie z uzyciem nauczonej sieci.
  y_all = ann_propagacja_wprzod(X, Wagi_macierze, param_warstw); % wyjscia z neuronow 
  [dummy, y_pred] = max( y_all, [], 2),                          % znalezienie max
  fprintf('Dokladnosc: %f\n', mean(double(y_pred == y ))*100);   % dokladnosc w [%]
  figure;
  k = 1 : L_przykladow;
  plot( k, y,'r-', k, y_pred,'bx'); grid; title('Wyniki rozpoznawania');
  xlabel('Nr testu'); ylabel('Rozpoznana wartosc');
  legend('zadane','rozpoznane','Location','southeast');

% Analiza wynikow
  C1 = hist( y_pred( nr_ok),        1 : L_klas );
  C2 = hist( y_pred( nr_alarm),     1 : L_klas );
  figure; imagesc( [ C1' C2' ] ); xlabel('zadane'); ylabel('rozpoznane');
  title('Confusion matrix - co jest podobne do czego?');
  C = [ [1 : L_klas]; [ C1' C2' ] ];
  confusion_matrix = [ [-1, 1 : L_klas ]' C ], pause
