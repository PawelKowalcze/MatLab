% FM Demodulation - All Three Methods in One Script

% Wczytaj sygnał FM z pliku
load('lab08_fm.mat');  % zmienna:  x

% Parametry
fs = 2e6;           % Częstotliwość próbkowania
fc = 200e3;         % Częstotliwość nośna
audio_fs = 8000;    % Częstotliwość próbkowania dźwięku

%% 1. Metoda I/Q

% Czas
N = length(x);
t = (0:N-1)/fs;

% Nośna
cos_carrier = cos(2*pi*fc*t);
sin_carrier = sin(2*pi*fc*t);

% Demodulacja I/Q
I = lowpass( x .* cos_carrier, 15e3, fs);
Q = lowpass(- x .* sin_carrier, 15e3, fs);

z = I + 1j*Q;
phase_diff_IQ = angle(z(2:end) .* conj(z(1:end-1)));
audio_IQ = resample(phase_diff_IQ, audio_fs, fs);
audio_IQ = audio_IQ / max(abs(audio_IQ));

%% 2. Metoda: Filtr BP + różniczkujący (kaskada)

% Filtr BP FIR
f_low = (fc - 100e3) / (fs/2);
f_high = (fc + 100e3) / (fs/2);
n = 300;
b_bp = fir1(n, [f_low f_high], 'bandpass', kaiser(n+1, 8));

% Filtr różniczkujący
b_diff = [-1 1];
a_diff = 1;

% Kaskada
b_cascade = conv(b_bp, b_diff);
y_fm_diff_bp = filter(b_cascade, 1,  x);
phase_diff_cascade = angle(y_fm_diff_bp(2:end) .* conj(y_fm_diff_bp(1:end-1)));
audio_cascade = resample(phase_diff_cascade, audio_fs, fs);
audio_cascade = audio_cascade / max(abs(audio_cascade));

%% 3. Metoda: Jeden filtr FIR (firls)

% Projekt FIRLS
f = [0 (fc-150e3)/(fs/2) (fc-100e3)/(fs/2) (fc+100e3)/(fs/2) (fc+150e3)/(fs/2) 1];
m = [0 0 1 1 0 0];
b_diff_bp_firls = firls(n, f, m);
y_fm_diff_bp_firls = filter(b_diff_bp_firls, 1,  x);
phase_diff_firls = angle(y_fm_diff_bp_firls(2:end) .* conj(y_fm_diff_bp_firls(1:end-1)));
audio_firls = resample(phase_diff_firls, audio_fs, fs);
audio_firls = audio_firls / max(abs(audio_firls));

%% Zapis do plików WAV
audiowrite('audio_IQ.wav', audio_IQ, audio_fs);
audiowrite('audio_cascade.wav', audio_cascade, audio_fs);
audiowrite('audio_firls.wav', audio_firls, audio_fs);

%% Porównanie wykresów

subplot(3,1,1);
plot(audio_IQ); title('Metoda I/Q'); xlabel('Próbki'); ylabel('Amplituda');

subplot(3,1,2);
plot(audio_cascade); title('Metoda BP + różniczka (kaskada)'); xlabel('Próbki'); ylabel('Amplituda');

subplot(3,1,3);
plot(audio_firls); title('Metoda FIRLS'); xlabel('Próbki'); ylabel('Amplituda');
