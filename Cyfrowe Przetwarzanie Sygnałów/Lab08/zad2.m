clear all; close all;

%% Filtr Hilberta (dla SSB-SC)
fs = 400e3;                       % częstotliwość próbkowania
fc = 100e3;                       % częstotliwość nośna
M  = 1024;                       
N  = 2*M+1;
n  = 1:M;
h  = (2/pi)*sin(pi*n/2).^2 ./n;  % teoretyczna odpowiedź impulsowa filtra Hilberta
h  = [-h(M:-1:1) 0 h(1:M)];      % pełna odpowiedź (symetryczna)
w  = blackman(N)';               % okno Blackmana
hw = h.*w;                      % odpowiedź filtra po oknie

%% Wczytanie sygnału audio
[x1,fs1] = audioread('mowa8000.wav');
x1 = x1';                       
x2 = fliplr(x1);                % druga stacja = odwrócona w czasie pierwsza

%% Parametry radiowe
fc1 = 100e3;                    % nośna 1 stacji
fc2 = 110e3;                    % nośna 2 stacji
dA  = 0.25;                    % głębokość modulacji

%% Resampling (dopasowanie próbkowania audio do radiowego)
xr1 = resample(x1, fs, fs1);
xr2 = resample(x2, fs, fs1);

% Filtracja Hilberta
xh1 = conv(xr1, hw); xh1 = xh1(M+1:length(xr1)+M);
xh2 = conv(xr2, hw); xh2 = xh2(M+1:length(xr2)+M);

t1 = length(x1)/fs1;            % czas trwania sygnału
t  = 0:1/fs:t1-1/fs;           % wektor czasu

%% Generowanie sygnałów AM
% DSB-C (AM z nośną)
Ydsb_c_a = (1+xr1).*cos(2*pi*fc1*t);
Ydsb_c_b = (1+xr2).*cos(2*pi*fc2*t);
Ydsb_c   = dA*(Ydsb_c_a + Ydsb_c_b);

% DSB-SC (AM bez nośnej)
Ydsb_sc_a = xr1.*cos(2*pi*fc1*t);
Ydsb_sc_b = xr2.*cos(2*pi*fc2*t);
Ydsb_sc   = dA*(Ydsb_sc_a + Ydsb_sc_b);

% SSB-SC (+) wstęga górna
Yssb_sc1_a = 0.5*xr1.*cos(2*pi*fc1*t) + 0.5*xh1.*sin(2*pi*fc1*t);
Yssb_sc1_b = 0.5*xr2.*cos(2*pi*fc2*t) + 0.5*xh2.*sin(2*pi*fc2*t);
Yssb_sc1   = dA*(Yssb_sc1_a + Yssb_sc1_b);

% SSB-SC (−) wstęga dolna
Yssb_sc2_a = 0.5*xr1.*cos(2*pi*fc1*t) - 0.5*xh1.*sin(2*pi*fc1*t);
Yssb_sc2_b = 0.5*xr2.*cos(2*pi*fc2*t) - 0.5*xh2.*sin(2*pi*fc2*t);
Yssb_sc2   = dA*(Yssb_sc2_a + Yssb_sc2_b);

%% Analiza widma
HYdsb_c   = fft(Ydsb_c);
HYdsb_sc  = fft(Ydsb_sc);
HYssb_sc1 = fft(Yssb_sc1);
HYssb_sc2 = fft(Yssb_sc2);
f = (0:length(HYdsb_c)-1)/length(HYdsb_c)*fs;

% Wykresy FFT
figure;
subplot(1,2,1); plot(f, abs(HYdsb_c)); title('fft DSB-C'); xlim([90e3 120e3]);
subplot(1,2,2); plot(f, abs(HYdsb_sc)); title('fft DSB-SC'); xlim([90e3 120e3]);

figure;
subplot(1,2,1); plot(f, abs(HYssb_sc1)); title('fft SSB-SC (+)'); xlim([90e3 120e3]);
subplot(1,2,2); plot(f, abs(HYssb_sc2)); title('fft SSB-SC (-)'); xlim([90e3 120e3]);

%% Demodulacja
% Funkcje pomocnicze
demod1 = @(y, fc) 2 * y .* cos(2*pi*fc*t);                        % detekcja synchroniczna dla DSB
demod2 = @(y, fc) y .* (cos(2*pi*fc*t) - 1i*sin(2*pi*fc*t));     % detekcja dla SSB

% DSB-C
Ydc1 = conv(demod1(Ydsb_c, fc1), hw); Ydc1 = real(Ydc1(M+1:end-M));
Ydc2 = conv(demod1(Ydsb_c, fc2), hw); Ydc2 = real(Ydc2(M+1:end-M));
Ydc2 = fliplr(Ydc2);    % odwrócenie drugiej stacji

% DSB-SC
Ysc1 = conv(demod1(Ydsb_sc, fc1), hw); Ysc1 = real(Ysc1(M+1:end-M));
Ysc2 = conv(demod1(Ydsb_sc, fc2), hw); Ysc2 = real(Ysc2(M+1:end-M));
Ysc2 = fliplr(Ysc2);

% SSB-SC (+)
Yssb1_1 = conv(demod2(Yssb_sc1, fc1), hw); Yssb1_1 = real(Yssb1_1(M+1:end-M));
Yssb1_2 = conv(demod2(Yssb_sc1, fc2), hw); Yssb1_2 = real(Yssb1_2(M+1:end-M));
Yssb1_2 = fliplr(Yssb1_2);

% SSB-SC (−)
Yssb2_1 = conv(demod2(Yssb_sc2, fc1), hw); Yssb2_1 = real(Yssb2_1(M+1:end-M));
Yssb2_2 = conv(demod2(Yssb_sc2, fc2), hw); Yssb2_2 = real(Yssb2_2(M+1:end-M));
Yssb2_2 = fliplr(Yssb2_2);

%% Eksperyment: dwie stacje na jednej nośnej (SSB-SC)
Yssb_mix = 0.5*xr1.*cos(2*pi*fc1*t) + 0.5*xh1.*sin(2*pi*fc1*t) + ...
           0.5*xr2.*cos(2*pi*fc1*t) - 0.5*xh2.*sin(2*pi*fc1*t);
Ymix_a = conv(demod2(Yssb_mix, fc1), hw); Ymix_a = real(Ymix_a(M+1:end-M));
Ymix1 = Ymix_a;  
Ymix2 = fliplr(Ymix_a);

%% Wykresy sygnałów zdemodulowanych
figure;
subplot(3,2,1); plot(Ydc1); title('DSB-C stacja 1');
subplot(3,2,2); plot(Ydc2); title('DSB-C stacja 2');
subplot(3,2,3); plot(Ysc1); title('DSB-SC stacja 1');
subplot(3,2,4); plot(Ysc2); title('DSB-SC stacja 2');
subplot(3,2,5); plot(Yssb1_1); title('SSB-SC(+) stacja 1');
subplot(3,2,6); plot(Yssb1_2); title('SSB-SC(+) stacja 2');

figure;
subplot(2,1,1); plot(Ymix1); title('SSB-SC mix stacja 1');
subplot(2,1,2); plot(Ymix2); title('SSB-SC mix stacja 2');

%% Testy dźwięku (odsłuch)
soundsc(resample(Ydc1, fs1, fs), fs1); pause(t1+1);
soundsc(resample(Ydc2, fs1, fs), fs1); pause(t1+1);
soundsc(resample(Ysc1, fs1, fs), fs1); pause(t1+1);
soundsc(resample(Ysc2, fs1, fs), fs1); pause(t1+1);
soundsc(resample(Yssb1_1, fs1, fs), fs1); pause(t1+1);
soundsc(resample(Yssb1_2, fs1, fs), fs1); pause(t1+1);
soundsc(resample(Ymix1, fs1, fs), fs1); pause(t1+1);
soundsc(resample(Ymix2, fs1, fs), fs1);
