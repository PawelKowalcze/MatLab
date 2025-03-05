% Przyklad 3.5:
% m-plik: przyklad_3_5.m
%
% Cyfrowe przetwarzanie sygnalow. Podstawy, multimedia, transmisja. PWN, Warszawa, 2014.
% Rozdzial 3. Sygnaly losowe i szumy. 
% Autorzy rozdzialu: Przemyslaw Korohoda, Adam Borowicz, Krzysztof Duda.
%
% Wiecej na stronie internetowej: http://teledsp.kt.agh.edu.pl
%
% Opracowanie przykladu: kwiecien 2013 r./PK.

clc;   clear;  close all;

N=2^10;   M=8;  K=N/M;                  % mamy zadbac, zeby sie zgadzalo (tj. K - liczba calkowita);

sigma=3;  mu=5; x=randn(1,N)*sigma+mu;  % generujemy szum;
x  = filter([1,1,1]/3,1,x);             % kolorujemy szum;
X  = reshape(x,M,K);                    % ukladamy bloki sygnalu w macierzy X;
m1 = mean(X')'; X1=X-m1*ones(1,K);      % odejmujemy srednie od wspolrzednych;
Rx = X1*X1',                            % wyznaczamy macierz kowariancji;

Y  = (Rx)^(-1/2)*X1;                    % wybielamy;
Ry = Y*Y' ,                             % sprawdzamy, czy wyszlo;

y  = Y(:)';                             % ... dokladniej sprawdzamy;
for m=1:M, Y1(m,:)=y(m:end-M+m); end;   % tworzymy bloki, ale na "zakladke";
Ry_test=(1/M)*Y1*Y1',                   % ponowna weryfikacja;

% KONIEC PRZYKLADU 3.5.