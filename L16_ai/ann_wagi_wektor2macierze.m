function Wagi_macierze = ann_wagi_wektor2macierze( Wagi_wektor, param_warstw )
% Rozpakowanie elementow wektora z wszystkimi wagami (jedna za druga)
% do struktury "cell" z kilkoma macierzami (kazda z wagami dla innej warstwy)

  L_warstw = length( param_warstw );         % liczba warstw sieci = macierzy wag
  Wagi_macierze = {};                        % wagi jako macierze dla kolejnych warstw 
  przesuniecie = 0;                          % offset w wynikowym wektorze wag 
  for nr_warstwy = 1 : (L_warstw-1)          % wszystkie warstwy bez wejsciowej (bez wag)
      L_in  = param_warstw( nr_warstwy );    % liczba wejsc do warstwy neuronow   
      L_out = param_warstw( nr_warstwy + 1); % liczby wyjsc, czyli liczba neuronow
      L_cech  = L_in + 1;                    % +1 gdyz pamieamy o w0 (bias)
      L_neuronow = L_out;                    % 
      L_elementow = L_neuronow*L_cech;       % liczba wszystkich elementow macierzy
      Wagi_warstwa = Wagi_wektor((przesuniecie + 1) : (przesuniecie + L_elementow), 1);
      Wagi_macierze{ nr_warstwy } = reshape( Wagi_warstwa, L_neuronow, L_cech );
      przesuniecie = przesuniecie + L_elementow;
  end

end % funkcji
