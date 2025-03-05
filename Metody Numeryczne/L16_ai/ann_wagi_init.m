function Wagi = ann_wagi_init( warstwy, w_zakres )
% Losowa inicjalizacja wag dla calej sieci neuronowej.
% Kazda warstwa ma swoja macierz "Wagi" o wymiarach:
% liczba wierszy = liczba wyjsc, liczba kolumn = liczba wejsc + 1 (dla w0 - offset/bias)
% Dla 400,25,10:    Wagi = 1×2 cell array {25x401 double} {10x26 double}
% Dla 400,25,15,10: Wagi = 1×3 cell array {25x401 double} {15x26 double} {10x16 double}

  L_param = length( warstwy );    % liczba parametrow: Lwe, L1, L2, ..., Lwy
                                  % L_we = L_cech, L_wy = L_klas
  Wagi = {};                      % struktura z macierzami wag wszystkich warstw 
  for nr = 1 : (L_param-1)        % numer warstwy - bez warstwy wyjsciowej
      L_in  = warstwy( nr );      % liczba wejsc
      L_out = warstwy( nr + 1 );  % liczba wyjsc (liczba neuronow w kolejnej warstwie)
      Wagi{ nr } = w_zakres * (2*rand(L_out, L_in+1 ) - 1); % losowo (+/-)*zakres
    % Wagi{ nr } = 1*ones(L_out, L_in+1 );  %  DO TESTOWANIA
  end
    %  Wagi{1}, Wagi{2}, pause    % TEST
end % funkcji


