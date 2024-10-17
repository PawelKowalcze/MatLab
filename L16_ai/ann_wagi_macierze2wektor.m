function Wagi_wektor = ann_wagi_macierze2wektor( Wagi_macierze )
% Ulozenie elementow macierzy wag kolejnych warstw w jeden dlugi wektor liczb

L_macierzy = length( Wagi_macierze ); % liczba komorek (cells) z macierzami
Wagi_wektor = [];                     % wektor wyjsciowy z elementami wszyskich macierzy
for nr_macierzy = 1 : L_macierzy      % dla kazdej komorki (macierzy)       
    Wagi_wektor = [ Wagi_wektor; Wagi_macierze{ nr_macierzy }(:) ]; % rozpakowanie
end                                                                 %

end % funkcji
