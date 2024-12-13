span=8; %ilosc symboli obejmowanych filtrem
sps=128; % liczba probek na symbol
M=4; %liczba punktów konstelacji
numSyms=10000; %liczba transmitowanych symboli modulacji
%TODO 1: wygeneruj numSyms liczb losowych z zakresu [0;M-1] użyj randi
x=randi([0;M-1],1, numSyms);
%TODO 2: na podstawie x wygeneruj odpowiednie symbole QPSK (użyj qammod)
modSig=qammod(x,M);

alfa=[0.01:0.05:0.99]; % wspolczynnik poszerzenia pasma filtru
for i=1:length(alfa)
%TODO 3: zaprojektuj filtr typu podniesiony cosinus o współczynniku poszerzenia pasma wynoszącym
% alfa(i) obejmujący "span" symboli z których każdy obejmuje "sps" próbek. Uzyj rcosdesign
rrcFilter = rcosdesign(alfa(i), span, sps);
%TODO 4: nadprobkuj sygnał sps krotnie i dokonaj filtracji. Uzyj funkcji upfirdn
txOut=upfirdn(modSig,rrcFilter,sps);
%TODO 5: wyznacz współczynnik szczytu sygnału txOut. Uzyj funkcji max, abs oraz mean
cf(i)=max(real(txOut)) / rms(txOut);
end
plot(alfa,cf);