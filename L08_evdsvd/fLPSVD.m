function [fest, dest]=fLPSVD(x,K,dt)
% metoda LP-SVD Kumaresana-Tuftsa
% x - analizowany sygnal
% K - przyjeta liczba skladowych (tlumionych kosinusow)

M = 2*K;                              % liczba skladowych zespolonych
N = length(x);                        % liczba probek 
P = floor(N*3/4);                     % przyjety rzad liniowej predykcji P = 3/4*N 
Y = hankel( x(2:N-P+1), x(N-P+1:N) ); % macierz probek z predykcja wstecz (do tylu)
y = x(1:N-P)';                        % wektor probek dla predykcji wstecz 
[U,S,V] = svd(Y,0);                   % SVD dla rownania Y*b=y (b-back) 
S = diag(S);                          % elementy na glownej przekatnej 
bias = mean(S(M+1:min([N-P,P])));     % przesuniecie
                                                          % obliczamy wsp. LP wstecz
b = -V(:,1:M) * (diag(1./(S(1:M)-bias)) * (U(:,1:M)'*y)); % uzywamy tylko M skladowych 
                                                          %
z = roots([ 1; b]);                   % pierwiastki wielomianu predykcji
p=log(z); p = p( find(real(p)>0) );   % ln()
Om = imag(p); [Om indx] = sort( Om, 'ascend' );  Om=Om(K+1:2*K);  % cz. katowe
D = real(p(indx(K+1:2*K)));                                       % tlumienia
fest = Om/(2*pi*dt);                  % czestotliwosci obliczone
dest = D/dt;                          % tlumienia obliczone
