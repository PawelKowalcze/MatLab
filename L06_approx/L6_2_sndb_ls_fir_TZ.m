

clear all; close all;

load sndb_prbs, whos, pause

u=u.';
y=y.';

figure;
subplot(211); plot(u(1:200),'r.-'); title('u(n)'); grid;
subplot(212); plot(y(1:200),'b.-'); title('y(n)'); grid; pause

M = 40;          % dlugosc odpowiedzi impulsowej
L = length(u);   % d³ugoœæ sygna³ów
L = 2*M;         % liczba równañ, minimum M, maksimum L-M+1

% Metoda parametryczna model FIR o dlugosci M
%U=[];
%for i=0:L-1
%    U=[U; u(M+i:-1:i+1)];
%end
U = toeplitz(u(M:M+L-1),u(M:-1:1));

Y = y( M:M+(L-1) )';
b = U \ Y;       %  pinv(X)*y;  % inv(X'*X) * X'*y = Rxx * rxy

h = b;
save h.dat h -ascii

fpr = 44100; dt=1/fpr; t=dt*(0:M-1);

% OdpowiedŸ impulsowa
figure; stem(t,b); title('h(t)'); xlabel('t[s]'); grid; pause

% Jej widmo
Nfft=1000; Nf=Nfft/2+1; 
df=fpr/Nfft; f1=0:df:fpr-df; f3=f1;
% FFT
H1=fft(b,Nfft);
% FREQZ
[ H2, f2 ] = freqz(b(1:M),1,Nf,fpr);

% Metoda nieparametryczna dla porownania
M = L;                 % od L do Nfft/2
ryu = xcorr(y,u,M);    % d³ugie y i u! przesuniête wektory, jeœli nie trafisz w pobli¿e to nie zrobisz z krótkich u(M:L)
ruu = xcorr(u,u,Nfft/2);
H3 = fft( ryu, Nfft ) ./ fft( ruu, Nfft );

figure; plot(f1,20*log10(abs(H1)),'ro-',f2,20*log10(abs(H2)),'kx-',f3,20*log10(abs(H3)),'b-');
title('|H(f)| [dB]'); xlabel('f[Hz]'); grid; pause

% Metoda dla coraz wiêkszej liczby równañ
LL = [50, 100, 200, 1000, 2000 ];
y = y + 0.1*randn(1,length(y));
for L=LL
    disp('Number of samples'); L,
    U=[];
    for i=0:L-1
        U=[U; u(M+i:-1:i+1)];
    end
    Y = y(M:M+(L-1))';
    b = U\Y;
    [ H2, f2 ] = freqz(b(1:M),1,Nf,fpr);
    figure
    subplot(211); stem(1:M,b);
    subplot(212); plot(f2,20*log10(abs(H2)),'r-'); pause
end
