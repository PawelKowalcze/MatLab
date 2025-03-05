% ai_8_ann_ekg.m

% Patrz program Matlaba "ECGAndDeepLearningExample.mlx"

  clear all; close all;

  load ECGdata.mat % ECGData.Data = 162 x 65536: 162 sygnaly po 65536 probek (128 probek na sekunde)
  disp('Wymiar macierzy z sygnalami:'); size(ECGData.Data), 
  whos, pause      % co zaladowalismy do pamieci

% Pobieramy tylko N probek zaczynajac od n1st-ej probki
  N = 2500; n1st = 44000;
  X = ECGData.Data(   1:162 , n1st+1 : n1st+N);  % 162 nagania

  figure
  subplot(311); plot( X(  1:96 ,:)' ); title('Arytmia');       % 96 nagrań arytmii
  subplot(312); plot( X( 97:126,:)' ); title('Niewydolnosc');  % 30 nagran zastoinowej niewydolnosci serca
  subplot(313); plot( X(127:162,:)' ); title('Normalny rytm'); % 36 nagran normalnego rytmu sinusoidalnego
  xlabel('nr probki'); pause

  figure
  subplot(312); plot( X(  1,:)' ); title('Arytmia pracy serca');       % 96 nagrań arytmii
  subplot(313); plot( X( 97,:)' ); title('Niewydolnosc pracy serca');  % 30 nagran zastoinowej niewydolnosci serca
  subplot(311); plot( X(127,:)' ); title('Normalny rytm pracy serca'); % 36 nagran normalnego rytmu sinusoidalnego
  xlabel('nr probki'); pause

  L_klas = 3;                                        % liczba testowanych klas: ARR, CHF, NSR
  [ L_przykladow, L_cech ] = size( X );              % liczba wzorcow i liczbz cech
  y = [ ones(96, 1); 2*ones(30, 1); 3*ones(36, 1) ]; % etykietowanie wzorcow (z jakiej klasy)

% #########################################################################
% STARY PROGRAM: ai_6_ann_cyfry.m 
% #########################################################################

% Trenowanie sztucznej sieci neuronowej
  max_iter = 40;          % liczba iteracji procedury optymalizacyjnej/minimalizacyjnej
  lambda = 0.01;          % wspolczynnk regularyzacji uzyty podczas minimalizacji
  wagi_zakres = 0.12;     % zakres zmiennosci podczas inicjalizacji wsp. wagowych
  param_warstw = [        % wartosci parametrow sieci
      L_cech,             % liczba wejsc (liczba cech/pikseli, u nas 400)
      25,                 % liczba neuronow w pierwszej warstwie ukrytej
    % 15,                 % liczba neuronow w drugiej warstwie ukrytej
      L_klas              % liczba neuronow w warstwie wyjsciowej (liczba klas, u nas 10 cyfr)
  ];
  Wagi_macierze   = ann_wagi_init( param_warstw, wagi_zakres );  % inicjalizacja wag
  Wagi_wektor     = ann_wagi_macierze2wektor( Wagi_macierze );   % macierze wag --> wektor
  optim_opcje     = optimset('MaxIter', max_iter );              % parametry optymalizacji
  uchwyt_funkcji = @(p) ann_koszt_gradient(p, param_warstw, X, y, lambda );    % uchwyt
  [ Wagi_wektor, koszt ] = fmincg( uchwyt_funkcji, Wagi_wektor, optim_opcje ); % optymal.
  Wagi_macierze = ann_wagi_wektor2macierze( Wagi_wektor, param_warstw );       % obliczone wagi

% Rozpoznawanie z uzyciem nauczonej sieci.
  y_all = ann_propagacja_wprzod( X, Wagi_macierze, param_warstw ); % wyjscia z wszystkich neuronow 
  [dummy, y_pred] = max( y_all, [], 2),                           % znalezienie maksymalnego wyjscia
  fprintf('Accuracy: %f\n', mean(double( y_pred == y )) * 100);   % dokladnosc rozpoznania w [%]
  figure;
  k = 1 : L_przykladow;
  plot( k, y,'r-', k, y_pred,'bx'); grid; title('Wyniki rozpoznawania');
  xlabel('nr testu'); ylabel('rozpoznana wartosc');
  legend('zadane','rozpoznane','Location','southeast');

% Analiza wynikow  
  C1 = hist( y_pred(  1:96 ), 1 : L_klas );
  C2 = hist( y_pred( 97:126), 1 : L_klas );
  C3 = hist( y_pred(127:162), 1 : L_klas );
  figure; imagesc( [ C1' C2' C3' ] ); xlabel('zadane'); ylabel('rozpoznane');
  title('Confusion matrix - co jest podobne do czego?');
  C = [ [1 : L_klas]; [ C1' C2' C3' ] ];
  confusion_matrix = [ [-1, 1 : L_klas ]' C ], pause

