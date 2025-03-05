function J = ann_funkcja_kosztu( Wagi_macierz, parametry_warstw, X, y, wsp_regularyzacji)
% Obliczanie funkcji "kosztu" sieci neuronowej
  L_warstw     = length( parametry_warstw );         % liczba warstw
  L_przykladow = size(X, 1);                         % ile przykladow
  L_klas       = parametry_warstw( end );            % ile klas

% Obliczenia "w przod" (feedforward) wejscie --> wyjscie dla sieci neuronowej
  y_pred = ann_propagacja_wprzod( X, Wagi_macierz, parametry_warstw );

% Ustawienie macierzy y_matrix wskazujacej przez "1" na poprawne wyjscie z sieci
% y jest wektorem o wymiarach L_przykladow x 1 (tylko numer klasy dla danego przykladu ) 
% W macierzy y_matrix ustawiamy 1 na pozycji numeru klasy
% Np. dla klasy 5 mamy [0 0 0 0 1 0 0 0 0 0]
  y_matrix = zeros( L_przykladow, L_klas );
  for i = 1 : L_przykladow
      y_matrix( i, y(i) ) = 1;  % dla i-tego przykladu "1" na pozycji y(i)  
  end

% Obliczenie wartosci skladnika regularyzacji - nie uwzgledniamy w0 zw. z bias/offset
  Wagi_warsty_sum = 0;
  for nr_warstwy = 1 : (L_warstw-1)
      Wagi_warstwy = Wagi_macierz{ nr_warstwy };
      Wagi_warsty_sum = Wagi_warsty_sum + sum( sum( Wagi_warstwy(:, 2:end) .^ 2 ) );
  end
  regul = (wsp_regularyzacji / (2 * L_przykladow)) * Wagi_warsty_sum;

% Obliczenie funkcji kosztu z regularyzacja
  J = (-1/L_przykladow) * sum(sum((y_matrix.*log(y_pred) + ...
                                    (1-y_matrix).*log(1-y_pred)))) + regul;
end % funkcji
