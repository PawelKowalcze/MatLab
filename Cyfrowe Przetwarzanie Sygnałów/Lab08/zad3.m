clear all; close all;

%% Dane trzech sygnałów sinusoidalnych
f1 = 1001.2; % Hz
f2 = 303.1;  % Hz
f3 = 2110.4; % Hz

fs1 = 8e3;
fs2 = 32e3;
fs3 = 48e3;

% Wektory czasu
t1 = 0:1/fs1:1-1/fs1;
t2 = 0:1/fs2:1-1/fs2;
t3 = 0:1/fs3:1-1/fs3;

% Sygnały sinusoidalne
x1 = sin(2*pi*f1*t1);
x2 = sin(2*pi*f2*t2);
x3 = sin(2*pi*f3*t3);

% Wyświetlenie fragmentów sygnałów
figure('Name','Fragmenty składowych sygnałow sinusoidalnych');
hold on;
plot(t1, x1, 'r');
plot(t2, x2, 'b');
plot(t3, x3, 'g');
title('Fragmenty składowych sygnałów sinusoidalnych');
legend('1001.2Hz','303.1Hz','2110.4Hz');
xlabel('Czas [s]');
ylabel('Amplituda');
xlim([0 1/f3]);
hold off;

%% Suma trzech sygnałów (analityczna, na bazie fs3)
x4 = sin(2*pi*f1*t3) + sin(2*pi*f2*t3) + sin(2*pi*f3*t3);

%% Upsampling (zwiększenie fs)
x1up = upsample(x1, fs3/fs1);
x2up = decimate(upsample(x2,3),2);
x4_upsampling = x1up + x2up + x3;

%% Resampling (przeskalowanie fs)
x1re = resample(x1, fs3, fs1);
[P, Q] = rat(fs3/fs2);
x2re = resample(x2, P, Q);
x4_resampling = x1re + x2re + x3;

%% Porównanie widma (FFT)
figure('Name','Porównanie widma - analityczny vs upsampling');
subplot(2,1,1);
plot(abs(fft(x4)),'b');
title('Widmo - sygnał analityczny');
xlim([0 0.5e4]);
subplot(2,1,2);
plot(abs(fft(x4_upsampling)),'b');
title('Widmo - sygnał po upsamplingu');
xlim([0 0.5e4]);

figure('Name','Porównanie widma - analityczny vs resampling');
subplot(2,1,1);
plot(abs(fft(x4)),'b');
title('Widmo - sygnał analityczny');
xlim([0 0.5e4]);
subplot(2,1,2);
plot(abs(fft(x4_resampling)),'b');
title('Widmo - sygnał po resamplingu');
xlim([0 0.5e4]);

%% Miksowanie plików WAV
[x1wav, fs1w] = audioread('x1.wav');
[x2wav, fs2w] = audioread('x2.wav');
x1wav = x1wav(:,1)'; % mono
x2wav = x2wav';

f_wav = 48e3; % target fs

% Resampling x1.wav
[P1,Q1] = rat(f_wav/fs1w);
x1_resamp = resample(x1wav, P1, Q1);
vector1 = linspace(1, length(x1wav), length(x1_resamp));
x1wav_interp = interp1(1:length(x1wav), x1wav, vector1);

% Resampling x2.wav
[P2,Q2] = rat(f_wav/fs2w);
x2_resamp = resample(x2wav, P2, Q2);
vector2 = linspace(1, length(x2wav), length(x2_resamp));
x2wav_interp = interp1(1:length(x2wav), x2wav, vector2);

% Miksowanie wav
miks = x1wav_interp;
miks(1:length(x2wav_interp)) = miks(1:length(x2wav_interp)) + x2wav_interp;

%sound(miks, f_wav); % odsłuch

%% Miksowanie syntetycznych sygnałów metodą interpolacji liniowej
target_fs = 48e3;
new_t = 0:1/target_fs:1-1/target_fs;
x1_lin = interp1(t1, x1, new_t, 'linear', 0);
x2_lin = interp1(t2, x2, new_t, 'linear', 0);
x3_lin = interp1(t3, x3, new_t, 'linear', 0);
x4_lin = x1_lin + x2_lin + x3_lin;

%% Miksowanie metodą splotu z sinc (sin(x)/x)
% Parametry
target_fs = 48e3;
new_t = 0:1/target_fs:1-1/target_fs;

% Obliczenie współczynnika zmiany fs
R1 = target_fs / fs1;
R2 = target_fs / fs2;

% Długość filtra (np. 101 próbek, żeby był symetryczny)
N = 101;
n = -(N-1)/2 : (N-1)/2;

% Filtr sinc dla x1 (z 8 kHz do 48 kHz)
h1 = sinc(n / R1);
h1 = h1 .* hamming(N)'; % okno Hamming'a dla ograniczenia wycieku

% Filtr sinc dla x2 (z 32 kHz do 48 kHz)
h2 = sinc(n / R2);
h2 = h2 .* hamming(N)';

% Upsample sygnałów
x1_up = upsample(x1, round(R1));
x2_up = upsample(x2, round(R2));

% Splot z filtrem sinc
x1_sinc = conv(x1_up, h1, 'same');
x2_sinc = conv(x2_up, h2, 'same');

% Przycinanie/próbkowanie do długości new_t
x1_sinc = interp1(1:length(x1_sinc), x1_sinc, linspace(1, length(x1_sinc), length(new_t)), 'linear', 0);
x2_sinc = interp1(1:length(x2_sinc), x2_sinc, linspace(1, length(x2_sinc), length(new_t)), 'linear', 0);
x3_sinc = interp1(1:length(x3), x3, linspace(1, length(x3), length(new_t)), 'linear', 0);

% Suma końcowa
x4_sinc = x1_sinc + x2_sinc + x3_sinc;


%% Porównanie metod
figure('Name','Porównanie metod miksowania');
subplot(3,1,1);
plot(x4_lin); title('Interpolacja liniowa');
subplot(3,1,2);
plot(x4_sinc); title('Rekonstrukcja sinc');
subplot(3,1,3);
plot(x4); title('Analityczny');

%% Opcjonalnie: implementacja metody Polyphase (z PulseAudio)
% Polyphase to filtr wielofazowy, często stosowany w mikserach softwarowych.
% Matlab: użycie dsp.FIRRateConverter (wymaga toolboxa).
% Jeśli chcesz, przygotuję kod dla tej metody — daj znać!

