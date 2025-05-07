clear all; close all;

load('lab08_am.mat');
x = s8;

%% Filtr Hilberta
% Generowanie teoretycznej odpowiedzi impulsowej
fs = 1000;                          % czestotliwosc probkowania
fc = 200;                           % czestotliwosc nosna
M  = 64;                            % polowa dlugosci filtra
N  = 2*M+1;
n  = 1:M;
h  = (2/pi)*sin(pi*n/2).^2 ./n;     % połowa odpowiedzi impulsowej
h  = [-h(M:-1:1) 0 h(1:M)];         % cała odpowiedź impulsowa

% Wymnażanie przez okno Blackmana
w  = blackman(N); 
w  = w';            
hw = h.*w;                   

%freqz(hw,1,512,fs);


%% widmo Fouriera oraz wykresy (analiza filtru, przed i po oknie)
%h(n) przed oknem, hw(n) po oknie
m = -M : 1 : M;                     % indeksy czasowe dla współczynników filtra
NF = 500;                           % liczba punktów częstotliwości
fn=0.5*(1:NF-1)/NF;                 % normalizacja częstotliwości

for k=1:NF-1
    H(k)  =sum (h  .* exp(-j*2*pi*fn(k)*m));
    HW(k) =sum (hw .* exp(-j*2*pi*fn(k)*m));
end

figure(Name="Charakterystyka filtru");
subplot(2,2,1);
stem(m,h); grid; title('h(n)'); xlabel('n');
subplot(2,2,2);
stem(m,hw); grid; title('hw(n)'); xlabel('n'); 
subplot(2,2,3);
plot(fn,abs(H)); grid; title('|H(fn)|'); xlabel('f norm]'); 
subplot(2,2,4);
plot(fn,abs(HW)); grid; title('|HW(fn)|'); xlabel('f norm]');

%% Filtracja odpowiedzią impulsową
xHT = conv(x,hw);           % filtracja sygnału x(n) za pomocą hw(n)
xHT = xHT(N:1000);          % odcięcie stanów przejściowych
x2  = x(M+1:1000-M);        % odcięcie tych próbek z x(n), dla których nie ma poprawnych odpowiedników w y(n)
m   = sqrt(x2.^2 + xHT.^2); % obwiednia to pierwiastek z sumy kwadratów sygnałów x i jego transformacji Hilberta HT(x).

%% FFT obwiedni
NFFT = 2^nextpow2(fs);
Y    = fft(m,NFFT)/fs;                  %transformata fouriera obwiedni
f    = fs/2*linspace(0,1,NFFT/2+1);

figure;
hold on;
plot(x2(1:200),'b'); 
plot(xHT(1:200),'k');
plot(m(1:200),'r'); 
title('Przedstawienie sygnału z pliku, jego transformaty i obwiedni (fragment)');
legend('x','HT(x)','obwiednia');
hold off;


figure('Name','FFT obwiedni')
plot(f,2*abs(Y(1:NFFT/2+1)),'b');
title('FFT obwiedni');

%% Odczytanie parametrów sygnału modulującego m(t)
[pks, locs] = findpeaks(2*abs(Y(1:NFFT/2+1)), 'SortStr','descend');

% Odczytanie częstotliwości i amplitud z FFT obwiedni
f1 = fn(locs(1));  f2 = fn(locs(2));  f3 = fn(locs(3));
A1 = pks(1);       A2 = pks(2);       A3 = pks(3);

%% Wyświetlenie parametrów
disp(['Częstotliwość f1: ' num2str(f1)]);
disp(['Częstotliwość f2: ' num2str(f2)]);
disp(['Częstotliwość f3: ' num2str(f3)]);
disp(['Amplituda A1: ' num2str(A1)]);
disp(['Amplituda A2: ' num2str(A2)]);
disp(['Amplituda A3: ' num2str(A3)]);
