% approx_poly.m
% Przyklad aproksymacji wielomianowej z baza jednomianow
% [x,y] - dane, M - stopien wielomianu, N - liczba danych 

clear all; close all;

M = 3;    % stopien wielomianu
N = 10;   % liczba punktow pomiarowych (N>=M oraz N<=10)

% W wyniku pomiaru otrzymano nastepujace liczby ( x = numer pomiaru, y = wartosc )
x = [ 1       2      3      4      5      6      7      8      9      10    ];
y = [ 0.912   0.945  0.978  0.997  1.013  1.035  1.057  1.062  1.082  1.097 ];
x = x(1:N).';
y = y(1:N).';

X = vander(x),               % macierz Vandermonde'a: kolejne potegi x w kolumnach
X = X(:,N-M:N), pause        % odcinamy pierwsze kolumny z najwiekszymi potegami
a = inv(X'*X)*X'*y;          % wspolczynniki od najwyzszej potegi
% Inaczej: 	a=U\y; 	 albo	 a=polyfit(x,y,n);
figure; plot(y-X*a,'ro-'); xlabel('xn'); title('ERR(xn)'); grid; pause  % odchylki

xi = min(x) : 0.1 : max(x);  % argumenty
yi = polyval(a,xi);		     % wartosci wielomianu w punktach
figure; plot(x,y,'ro',xi,yi,'b-'); xlabel('x'); title('y=f(x)'); grid; pause
