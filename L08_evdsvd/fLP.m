function [fest, dest] = fLP(x,K,dt)
% Metoda LP Prony'ego
% x - analizowany sygnal
% K - przyjeta liczba skladowych (tlumionych kosinusow)
N = length(x);                             % liczba probek danych
P = 2*K;                                   % rzad predykcji
M = N-P;                                   % maksymalna liczba rownan
FirstCol = x(1:M); LastRow = x(M:M+P-1);   % parametry dla macierzy Hankela 
Y = hankel( FirstCol, LastRow );           % macierz MxL
y = x(P+1:P+M).';                          % wektor Mx1

%a = -pinv(Y)*y;                           % 1) klasyczne rozwiazanie
a = -Y\y;                                  % 2) optymalizowane rozwiazanie Matlaba
%[U,S,V] = svd(Y,0); S = diag(S);          % 3) "nasze" rozwiazanie
%a = -V * (diag(1./S) * (U'*y));           % 3) macierz pseudoodwrotna z SVD 

p = log( roots( [1 fliplr(a')] ) );        % pierwiastki wielomianu a
Om = imag(p); [Om indx] = sort( Om, 'ascend' ); Om = Om(K+1:2*K); % cz. katowe
D = -real( p(indx(K+1:2*K)) );                                    % tlumienia
fest = Om/(2*pi*dt);                       % czestotliwosci obliczone
dest = D/dt;                               % tlumienie obliczone