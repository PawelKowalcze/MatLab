% svd_ar.m
clear all; close all;

N = 200;                    % liczba analizowanych probek danych
fpr = 10000; dt = 1/fpr;    % liczba probek danych na sekunde, okres probkowania
f = [ 1000  2000  3000  ];  % liczba powtorzen na sekunde skladowych sinusoidalnych
d = [ 1     10    20    ];  % tlumienie kolejnych skladowych
A = [ 1     0.5   0.25  ];  % amplituda kolejnych skladowych
K = length(f);              % liczba skladowych sygnalu
x = zeros(1,N);             % inicjalizacja danych 
for k = 1 : K               % generacja i akumulacja kolejnych sinusoid  
    x =  x + A(k) * exp(-d(k)*(0:N-1)*dt) .* cos(2*pi*f(k)*(0:N-1)*dt + pi*rand(1,1));
end
SNR = 60; x = awgn(x,SNR);                   % dodanie szumu, poziom w decybelach
figure; plot(x); grid; title('x(n)'); pause  % pokazanie sygnalu
[fest1, dest1 ] = fLP(x,K,dt),               % metoda LP Prony'ego 
[fest2, dest2 ] = fLPSVD(x,K,dt),            % metoda LP-SVD Kumaresana-Tuftsa
[fest1 fest2], [dest1 dest2],                % porownanie 
