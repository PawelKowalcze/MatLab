
% Lab 6.1: Aproksymacja - regresja liniowa
%          Rozwiazanie rownania algebraicznego A * x = b

  A = [ 14 32 23; ...
        32 77 68; ...
        23 68 113 ]   % zdefiniuj macierz A
  x = [ 1 2 3 ]'      % zdefiniuj wektor x
  b = A * x           % oblicz b, x z wiersza na kolumne
  pause               % czekaj

  clc                 % wyczysc ekran
                      % odtworz x na podstawie A i b
  x
  xe1 = inv(A) * b    % za pomoca macierzy odwrotnej
  xe2 = A \ b         % poprzez dzielenie macierzowe
  pause               % czekaj
