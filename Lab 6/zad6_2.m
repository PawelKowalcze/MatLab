% Definicja macierzy A i wektora b
A = [5, 7; 4, 3; 7, 6; 10, 1];
b = [1; 2; 3; 4];

% Dekompozycja QR macierzy A
[Q, R] = qr(A);

% Obliczenie Q^T * b
Q_T_b = Q' * b;

% Wyciągnięcie górnej części R (R1) i odpowiedniej części Q^T * b (r2)
% R1 jest rozmiaru 2x2, ponieważ A ma więcej wierszy niż kolumn
R1 = R(1:2, 1:2);
r2 = Q_T_b(1:2);

% Rozwiązanie układu R1 * x = r2 za pomocą podstawienia wstecznego
x = R1 \ r2;

% Wyświetlenie wyniku
disp('Rozwiązanie x:');
disp(x);