% Wektory i macierze w Matlabie
% Program matlab_matrices.m
clear all; close all;   % zerowanie pamieci, usuwanie rysunkow
echo on                 % wyswietlanie linii programu na ekranie

% Definiowanie wektorow i macierzy
h = [ 1, 2, 3 ],   % wektor poziomy h, elementy oddzielone przecinkiem
v = [ 4; 5; 6 ],   % wektor pionowy v, elementy oddzielone srednikiem
H = [ h; h; h ],   % macierz H jako wynik skladania poziomych wierszy
V = [ v, v, v ],   % macierz V jako wynik skladania pionowych kolumn
ht = h', Ht = H',  % (') transpozycja plus sprzezenie zespolone (.') tylko transpozycja
A = rand(3,3),     % macierz A (liczb losowych) o wymiarach 3x3
B = A(2:3,2:3),    % macierz B jako wycinek macierzy A: od 2-go do 3-go wiersza/kolumny
Nh = length(h),    % liczba elementow wektora h
[M,N] = size(H),   % wymiary macierzy H

% Operacje wektorowo-macierzowe
liczba = h*v,          % iloczyn skalarny:  wektor poziomy razy pionowy -> jedna liczba 
macierz = v*h,         % iloczyn wektorowy: wektor pionowy razy poziomy -> macierz 
wektor1 = H*v,         % iloczyn macierzy i wektora pionowego
wektor2 = h*H,         % iloczyn wektora poziomego i macierzy
HdV = H+V, HmV = H*V,  % dodawanie i mnozenie macierzy
C(4,4) = h(1)+V(2,3),  % suma jednego elementu wektora h oraz macierzy V

% Operacja poprzedzona "." jest wykonywana na odpowiadajacych sobie elementach
% dwoch wektorow lub macierzy                    
potega  = h.^2,        % druga potega kazdego elementu wektora h 
iloczyn = h .* v',     % iloczyn odpowiadajacych sobie elementow dwoch wektorow
iloraz  = V ./ H,      % iloraz odpowiadajacych sobie elementow dwoch macierzy

% Przykladowe funkcje wykonywane na wektorach/macierzach
hsum  = sum(h),        % suma wszystkich elementow wektora h
hcumsum = cumsum(h),   % kumulowana suma wszystkich elementow wektora h
hmult = prod(h),       % iloczyn wszystkich elementow wektora h
hcumprod = cumprod(h), % kumulowany iloczyn
Vmean = mean(V),       % wartosc srednia poszczegolnych kolumn macierzy V
Vstd = std(mean(V)),   % odch. standardowe wartosci srednich kolumn macierzy V
di = diag(A),          % elementy lezace na przekatnej macierzy A
de1 = det(A),          % wyznacznik macierzy kwadratowej
p = poly(A),           % wspolczynniki wielomianu charakterystycznego macierzy A
r = roots(p),          % pierwiastki (miejsca zerowe) tego wielomianu
de2 = prod(r),         % wyznacznik macierzy jako iloczyn pierwistkow, porownaj z de1
Ainv = inv(A),         % odwrotnosc macierzy
I = A*inv(A),          % powinna byc macierz identycznosciowa 
b=A*v, vest=inv(A)*b,  % oblicz v, znajac watosci macierzy A oraz wektora b 
whos                   % pokazanie zawartosci pamieci
