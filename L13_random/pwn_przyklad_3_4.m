% Przyklad 3.4:
% m-plik: przyklad_3_4.m
%
% Cyfrowe przetwarzanie sygnalow. Podstawy, multimedia, transmisja. PWN, Warszawa, 2014.
% Rozdzial 3. Sygnaly losowe i szumy. 
% Autorzy rozdzialu: Przemyslaw Korohoda, Adam Borowicz, Krzysztof Duda.
%
% Wiecej na stronie internetowej: http://teledsp.kt.agh.edu.pl
%
% Opracowanie przykladu: kwiecien 2013 r./AB/PK.

clc; close all; clear;

N= 2^14;                    % dlugosc przykladowej realizacji szumu;
fpr = 8000;                 % zakladamy czestotliwosc probkowania;
a = 0.9;                    % parametr filtra dolnoprzepustowego;
b1=[1-a]; a1=[1,-a];        % wspolczynniki filtra (patrz rozdzial 4);

[H1,W1] = freqz(b1,a1,1000); % chki-filtra (patrz rozdzial 4)
f1 = fpr*W1/(2*pi);

sigma = 3;                  % odchylenie standard. dla PDF szumu bialego;
x = randn(1,N)*sigma;       % generujemy relizacje procesu (szum bialy);
y = filter(b1,a1,x);        % modyfikujemy pasmo szumu przez filtracje;

    figure(1)
    subplot(231); plot(x(1:1000));
    subplot(232); hist(x,20);
    subplot(233); plot( pwelch(x,256) );
    subplot(234); plot(y(1:1000));
    subplot(235); hist(y,20);
    subplot(236); plot( pwelch(y,256) );
    pause

[P,W2] = pwelch(y,256);     % wyznaczamy periodogram;
f2 = fpr*W2/(2*pi);

Pbis=P*pi/(sigma^2);        % przeliczenia (pytanie-zadanie: dlaczego tak?);

    figure(2);
    plot(f2,10*log10(Pbis),'r.-');          grid on;    hold on;
    plot(f1,20*log10(abs(H1)),'c.-'); 
         xlabel('f [Hz]');    ylabel('[dB]');
         title('Porownanie ch-ki amplitudowej filtra "kolorujacego" i PSD otrzymanego szumu');
         legend('PSD szumu kolorowego','ch-ka filtra (odpowiednio przeliczona)');
        
% KONIEC PRZYKLADU 3.4.        