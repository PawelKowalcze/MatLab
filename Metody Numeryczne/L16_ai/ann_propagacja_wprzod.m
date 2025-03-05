function wyjscia = ann_propagacja_wprzod( X, Wagi_macierze, param_warstw )
% Propagacja informacji "w przod" w sieci neuronowej: wejscie --> wyjscie

  L_warstw = length( param_warstw );   % liczba warstw sieci
  L_przykladow = size(X, 1);           % liczba wszystkich przykladow

  x = [ ones(L_przykladow, 1), X];                 % dla warstwy pierwszej ukrytej 
  for nr_warstwy = 1 : (L_warstw-1)                % po kolei wszystkie warstwy
      Wagi_1macierz = Wagi_macierze{ nr_warstwy }; % macierz danej warstwy
      z = x * Wagi_1macierz';                      % we --> wy w danej warstwie
      y = sigmoid(z);                              % funkcja decyzyjna/aktywacji neuronu
      y = [ ones(L_przykladow, 1), y ];            % dodaj w0 (bias)
      x = y;               % wyjscie poprzedniej warstwy jest wejsciem nastepnej warstwy 
  end
  wyjscia = x(:, 2:end);               % warstwa wyjsciowa nie ma w0 (bias) 

end % funkcji
