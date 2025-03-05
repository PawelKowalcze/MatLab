
% ai_6_ann_cyfry.m
% Rozpoznawanie cyfr z uzyciem sztucznej sieci neuronowej

clear all; close all;

% Wczytanie danych (obrazow)
  load cyfry.mat       % 10 razy po 500 obrazkow 20x20 pikseli na jedna cyfre  
                       % macierz X: 5000 wierszy po 400 liczb w wierszu
  whos, pause          % co zaladowalismy do pamieci
  L_klas = 10;         % liczba testowanych klas/cyfr 0,1,2,...,9 (0 = klasa10)
  L_wzorcow = 500;     % liczba wzorcow dla kazdej klasy/cyfry 
  L_x = 20;            % liczba pikseli kazdego obrazu-wzorca w poziomie 
  L_y = 20;            % liczba pikseli kazdego obrazu-wzorca w pionie

  L_przykladow = L_klas *L_wzorcow; % liczba wszystkich wzorcow/obrazow
  L_cech  = L_x * L_y;              % liczba wszystkich cech/pikseli pojedynczego obrazu

% Pokaz wybrane obrazy wzorcow (jeden obraz ma L_wzorcow)
if(1)
  n1st = ceil( rand(1,1)*L_wzorcow );     % od 1 do L_wzorcow
  figure;
  for nr = n1st : L_wzorcow : L_przykladow
      nr
      img = X( nr, 1 : L_cech );          % cechy to kolejne piksele
      img = reshape( img, L_y, L_x );
      imagesc( img ); pause(0.25)
  end
  figure; plot(y); xlabel('nr przykladu'); ylabel('nr klasy'); grid;
  title('Ch-ka danych'); pause
end
y,pause

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
  C = hist( reshape(y_pred, L_wzorcow, L_klas), 1 : L_klas );
  C = [ C(:, 2:end) C(:,1) ];
  figure; imagesc(log10(C+1)'); title('Macierz pomylek - co jest podobne do czego?');
  xlabel('Rozpoznana cyfra'); ylabel('Testowana cyfra'); axis square;

  C = [ [1:9, 0]; C' ],
  confusion_matrix = [ [-1, 1:9, 0]' C ], pause
