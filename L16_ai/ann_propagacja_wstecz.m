function gradienty=ann_propagacja_wstecz(Wagi_macierze, parametry_warstw, X, y, lambda)
% Propagacja wsteczna bledu w celu obliczenia gradientow wplywu zmiany wag  

  L_warstw     = length( parametry_warstw );         % liczba warstw
  L_przykladow = size(X, 1);                         % liczba przykladow
  L_klas       = parametry_warstw( end );            % liczba klas

  Delta = {};                                        % deklaracja struktury gradientow
  for nr_warstwy = 1 : (L_warstw-1)                  % dla wszystkich warstw
      L_we = parametry_warstw( nr_warstwy );         % liczba wejsc
      L_wy = parametry_warstw( nr_warstwy + 1 );     % liczba wyjsc
      Delta{ nr_warstwy } = zeros( L_wy, L_we + 1 ); % inicjalizacja struktury gradientow
  end

% Powtorzenie dla wszystkich przykladow treningowych 
  for i = 1 : L_przykladow
      % "c, "z" - wejscie i wyjscie z kazdej warstwy bez sigmoid
        C = {};                      % struktura z wektorami wejsciowymi do warstw
        Z = {};                      % struktura z wektorami wyjsciowymi z  warstw
      % Ustawienie aktywacji pierwszej warstwy w kolejnym przykladzie
        c = [1; X(i, :)'];           % pierwszy wektor wejsciowy dla i-tego przykladu 
        C{1} = c;                    % zapamietanie w strukturze z wektorami wejsc.
      % Przetworzenie [wejscie --> wyjscie] dla calej sieci dla danego przykladu
      for nr_warstwy = 1 : (L_warstw-1)   % propagacja wprzod warstwa po warstwie
          Wagi_warstwy_1macierz = Wagi_macierze{ nr_warstwy }; % pobranie macierzy wag
          z = Wagi_warstwy_1macierz * c;  % wy = suma( we * wagi ) dla calej warstwy 
          wyjscie = [1; sigmoid(z)];      % funkcja sigmoidalna dla wy calej warstwy
          c = wyjscie;                    % obecne wyjscie to nastepne wejscie                                       
          C{ nr_warstwy + 1 } = c;        % zapamietanie wektora w strukturze wejsc
          Z{ nr_warstwy + 1 } = z;        % zapamietanie wektora w strukturze wyjsc
      end
    % Usuniecie bias/offsetu dodanego do wyjscia z ostatniej warstwy ("undo")
      y_wyjscie = c(2:end, :);
         %  C{1}, C{2}, C{3}, Z{2}, Z{3}, pause  % TEST
    
    % Obliczenie przyrostow funkcji dla wszystkich warstw oprocz wejsciowej
    % Inicjalizacja struktury z macierzami bledow dla wszystkich warstw
      delta = {};
    % Przeksztalcenia numeru klasy do postaci wektora z "1" odpowiednim wierszu
    % (np.. klasa=5 --> [0; 0; 0; 0; 1; 0; 0; 0; 0; 0])
      y_wzorzec = ( 1 : L_klas == y(i) )';
    % Obliczenie bledu dla ostatniej warstwy (wyjsciowej) dla obecnego przykladu
      delta{ L_warstw } = y_wyjscie - y_wzorzec;

    % Obliczenie bledow dla warstw ukrytych dla obecnego przykladu (backpropagation)
      for ilewstecz = 1 : (L_warstw-2)                            % ktora warstwa od tylu
          nr_warstwy_przed = L_warstw - ilewstecz;                % L_warstw-1, ..., 2.
          wagi_warstwy_po = Wagi_macierze{ nr_warstwy_przed };    % wagi warstwy po (inaczej)
          delta_warstwy_po = delta{ nr_warstwy_przed + 1 };       % blad warstwy po
          z_warstwy_przed = Z{ nr_warstwy_przed };                % "z" warstwy przed
          delta{ nr_warstwy_przed } = ( wagi_warstwy_po' * delta_warstwy_po ) .* ...
                 [1; sigmoid_gradient(z_warstwy_przed)];   % !!! propagacja bledu wstecz
          delta{ nr_warstwy_przed } = delta{ nr_warstwy_przed }(2:end); % usuniecie bias
      end
          %  delta{1}, delta{2}, delta{3}, pause % TEST
          %  C{1}, C{2}, C{3}, pause             % TEST
     % Akumulacja gradientow funkcji dla kazdego przejscia dla kolejnych przykladow
       for nr_warstwy = 1 : (L_warstw-1)
           Delta{nr_warstwy} = Delta{nr_warstwy} + delta{nr_warstwy+1}*C{nr_warstwy}';
       end
           % Delta{1}, Delta{2}, pause % TEST

  end % koniec przetwarzania wszystkich przykladow

 % Obliczenie wspolczynnikow regularyzacji dla poszczegolnych warstw
 % (pierwsza kolumna macierzy "Wagi_macierze" nie powinna byc regularyzowana)
   regular = {};
   for nr_warstwy = 1 : (L_warstw-1)
       Delta_warstwy = Delta{ nr_warstwy };
       regular{ nr_warstwy } = (lambda / L_przykladow) * ...
                 [ zeros( size(Delta_warstwy, 1), 1) Delta_warstwy(:, 2:end) ];
   end

 % Obliczenie gradientow dla funkcji kosztu z regularyzacja
   for nr_warstwy = 1 : (L_warstw-1)
       Delta{nr_warstwy} = (1/L_przykladow)*Delta{nr_warstwy} + regular{nr_warstwy};
   end

 % Konwersja do postaci wektora
   gradienty = ann_wagi_macierze2wektor( Delta );

end % funkcji
