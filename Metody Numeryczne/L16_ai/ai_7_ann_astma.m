
% ai_7_ann_astma.m
% Rozpoznawanie oddech normalny vs. astmatyczny z uzyciem sztucznej sieci neuronowej

  clear all; close all;

% Wczytanie danych

  load astma.mat  % pobierz wszystkie dane dla problemu rozpozania astmy w dzwieku oddechu
  whos, pause     % co zaladowalismy do pamieci

% Wybor rodzaju danych wejsciowych 
  
  wybor_cech = 0;     % 0 = sygnaly:        oddechy_Astma i oddechy_Norma 
                      % 1 = widma 1D:       widma1D_Astma i widma1D_Norma
                      % 2 = widma 2D:       widma2D_Astma i widma2D_Norma
                      % 3 = cechy {ASE,TI}: aseti_Astma i   aseti_Norma

  L_klas = 2,         % liczba testowanych klas: chory/zdrowy

% Wybranie danych/cech do dalszego przetwarzania przez siec neuronowa
  
  if( wybor_cech == 0 )              % 130 (sygnaly) x 1024 (probki) dla Astmy i Normy
      cechy_Astma = oddechy_Astma;
      cechy_Norma = oddechy_Norma;
  elseif( wybor_cech == 1 )          % 130 (sygnaly) x 36 wspolczynnikow widmowych DFT
      cechy_Astma = widma1D_Astma;   % z zakresu 125-1220 Hz
      cechy_Norma = widma1D_Norma;
  elseif( wybor_cech == 2 )          % 130 (sygnaly) x 625 wsp. widmowych STFT
      cechy_Astma = widma2D_Astma;   % 625 = 25x25 (x = czestotliwosc, y = czas) 
      cechy_Norma = widma2D_Norma;
  elseif( wybor_cech == 3 )          % 130 (sygnaly) x 2 cechy ASE+TI wczesniej obliczone
      cechy_Astma = aseti_Astma;    
      cechy_Norma = aseti_Norma;
  else
      disp('BLAD! Zly parametr wyboru cech wejsciowych! Konczymy.'); exit;
  end

% Podstawienie dla dalszej czesci programu

  [ L_wzorcow, L_cech ] = size( cechy_Astma );  % liczba wzorcow i cech dla kazdej klasy
  X = [ cechy_Astma; cechy_Norma ];                disp('Wymiary X:'); size(X),
  y = [ ones(L_wzorcow, 1); 2*ones(L_wzorcow, 1)]; disp('Wymiary y:'); size(y),

% Rysunki

  figure; plot(y,'bx'); xlabel('nr przykladu'); ylabel('nr klasy'); grid; title('Ch-ka danych'); pause
  figure;
  if( wybor_cech == 0 )
      subplot(121); plot( cechy_Astma' ); title('Sygnaly Astmy'); xlabel('Nr probki czasu'); grid;
      subplot(122); plot( cechy_Norma' ); title('Sygnaly Normy'); xlabel('Nr probki czasu'); grid; pause
  elseif( wybor_cech == 1 )
      subplot(121); plot( cechy_Astma' ); title('Widma Astmy'); xlabel('Nr częstotliwosci'); grid;
      subplot(122); plot( cechy_Norma' ); title('Widma Normy'); xlabel('Nr częstotliwosci'); grid; pause
  elseif( wybor_cech == 2 )
      L_x = 25; L_y = 25;
      for nr = 1 : 10  % z zakresu [ 1, 2, 3,..., 130 = L_wzorcow]
          nr
          img1 = X( nr, 1 : L_cech );             % kolejny wzorzec widma 2D astmy
          img1 = reshape( img1, L_y, L_x );
          subplot(121); imagesc( img1 );  title('Astma'); xlabel('Nr częstotl.'); ylabel('Nr czasu'); 
          img2 = X( nr+L_wzorcow, 1 : L_cech );   % kolejny wzorzec widma 2D normy
          img2 = reshape( img2, L_y, L_x );
          subplot(122); imagesc( img2 );  title('Norma'); xlabel('Nr częstotl.'); ylabel('Nr czasu');
          pause; % (0.5)
      end
  elseif( wybor_cech == 3 )
     plot( cechy_Norma(:,1), cechy_Norma(:,2), 'bs','MarkerFaceColor','g');
     hold on;
     plot( cechy_Astma(:,1), cechy_Astma(:,2), 'ko','MarkerFaceColor','r');
     xlabel('Cecha 1 - ASE'); ylabel('Cecha 2 - TI'); grid;
     legend('Norma/dobre','Astma/zle');
     pause
  end

% #########################################################################
% STARY PROGRAM: ai_6_ann_cyfry.m 
% #########################################################################

  L_przykladow = L_klas *L_wzorcow;  % liczba wszystkich wzorcow/obrazow

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
  C = hist( reshape(y_pred, L_wzorcow, L_klas), 1 : L_klas );
  figure; imagesc( log10(C+1)' ); xlabel('zadane'); ylabel('rozpoznane');
  title('Confusion matrix - co jest podobne do czego?');
  C = [ [1 : L_klas]; C ];
  confusion_matrix = [ [-1, 1 : L_klas ]' C ], pause
