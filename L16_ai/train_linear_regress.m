function w = train_linear_regress( X, y )
% adaptacja LMS wag w dla y = w0 + w1*x1 + w2*x2 + ... 
% X - macierz NxM cech (N przykladow (wierszy), M-1 cech (koulmn)); pierwsza kolumna jedynek dla w0) 
% y - wektor Nx1 
% tak jak w przykladzie ai_1_kwatera.m 
 
[N,M] = size(X);

Niter = 250;   % liczba cykli uczenia, tzw. epoch
mi = 0.025;    % wsp. szybkosci uczenia
lambda = 0.;   % wsp. regularyzacji

% Normalizacja wartości kazdej cechy - bez jedynek zwiazanych ze wspolczynnikiem w0
Xmean = mean( X(:,1:M) );            % oblicz srednia   kazdej cechy (kolumny)
Xstd  =  std( X(:,1:M) );            % oblicz odch.std. kazdej cechy (kolumny)
X(:,2:M) = X(:,2:M) -  Xmean(2:M);   % odejmij srednie w kolumnach
X(:,2:M) = X(:,2:M) ./ Xstd(2:M);    % podziel przez odchylenia standardowe w kolumnach

% Adapatacja wartosci wag
% w = zeros(M,1);                            % wartosci poczatkowe - same zera
  w = pinv(X(1:M,1:M))*y(1:M,1);             % wartosci poczatkowe - 1-sza estymata
for n = 1 : Niter                            % POCZATEK PETLI ################
    err = X*w - y;                           % wektor roznic/bledow
    w = w - mi*(X'*err)/N;                   % adaptacja wag bez regularyzaci
  % w = w*(1-mi*lambda/N) - mi*(X'*err)/N;   % adaptacja wag z regularyzacja
    err_hist(n) = err' * err / N;            % zapamietanie bledu - wartosci f. kosztu 
end                                          % KONIEC PETLI #################
figure; plot(err_hist,'b-'); title('J( iter )');
xlabel('Numer iteracji'); ylabel('Wartosc funkcji kosztu'); grid; pause  % rysunek

% Denormalizacja wspolczynnikow, kolejno w0, w1, w2
Xmean = Xmean'; Xstd = Xstd';                % transpozycja wektorow
w(1) = w(1) - sum( w(2:end) .* Xmean(2:end) ./ Xstd(2:end) ); 
w(2:end) = w(2:end) ./ Xstd(2:end);
