% equnonlin_sinperiod.m
clear all; close all;

L = 1000;                          % liczba powtorzen testu
dt = 0.01;                         % okres probkowania
t = -0.25 : dt : 1.25;             % chwile pobieranie probek, 1.5 okresu danych

for i = 1 : L                      % PETLA GLOWNA
  
  % sygnal
  T = 1 + 0.05*randn;                     % losowa wartosc okresu w okolicy 1 sekundy
  w = 2*pi*(1/T);                         % 2*pi*czestotliwosc
  y = sin( w*t + 2*pi*0.05*randn );       % zbior probek danych 

  % Proste zliczanie                      % od ZBOCZA-+ 1 do ZBOCZA-+ 2
  ys = sign(y);  yz = diff(ys);           % znak, roznica znaku
  iz = find( yz>0 );                      % indeksy skoku wartosci "-" --> "+" 
  count = iz(2)-iz(1);  Tep = count*dt;   % estymata 1
  
  % Interpolacja pierwszego stopnia       % na ZBOCZU-+ 1 i ZBOCZU-+ 2, potem roznica 
  y1 = y(iz(1));      y2=y(iz(1)+1);      % y1=ostatnia ujemna, y2=pierwsza dodatnia
  dt1 = dt*y2/(y2-y1);                    % liniowa interpolacja czasu ZBOCZA 1
  y1 = y(iz(2));      y2=y(iz(2)+1);      % y1=ostatnia ujemna, y2=pierwsza dodatnia
  dt2 = dt-dt*y2/(y2-y1);                 % liniowa interpolacja czasu ZBOCZA 2
  Tei = (count-1)*dt + dt1 + dt2;         % estymata 2

  % Interpolacja trzeciego stopnia        % na ZBOCZU-+ 1 i ZBOCZU-+ 2, potem roznica
  p = polyfit(-1:2,y(iz(1)-1:iz(1)+2),3); % wsp. wielomianu na 3 punktach ZBOCZA 1
  r = roots(p);  ir = find(imag(r)==0);   % miejsca zerowe wielomianu, tylko real
  ic = find(r(ir)>=0 & r(ir)<=1);         % tylko w przedz. [0,1]
  dt1 = dt*(1-r(ic));                     % szescienna interpolacja czasu ZBOCZA 1
  p = polyfit(-1:2,y(iz(2)-1:iz(2)+2),3); % wielomian na 3 punktach ZBOCZA 2
  r = roots(p);  ir=find(imag(r)==0);     % miejsca zerowe wielomianu, tylko real
  ic = find(r(ir)>=0 & r(ir)<=1);         % tylko w przedz. [0,1]
  dt2 = dt*r(ic);                         % szescienna interpolacja czasu ZBOCZA 1
  Tea = (count-1)*dt+dt1+dt2;             % estymata 3
  
  % Zapamietanie wynikow
  Tref(i)=T;
  Tp(i) = Tep; Ti(i) = Tei; Ta(i) = Tea;
end
dTp = (Tp-Tref) ./ Tref;            % Blad metoda 1: przejscia przez zero
dTi = (Ti-Tref) ./ Tref;            % Blad metoda 2: interpolacja liniowa
dTa = (Ta-Tref) ./ Tref;            % Blad metoda 3: interpolacja szescienna
figure;
subplot(311); plot( dTp ); title( 'BLAD(iter) dla LiczZero' );
subplot(312); plot( dTi ); title( 'BLAD(iter) dla Interp 1' );
subplot(313); plot( dTa ); title( 'BLAD(iter) dla Interp 3' ); xlabel('iter'); pause
figure;
subplot(311); hist(dTp, 25); title( 'HIST(blad) dla LiczZero' );
subplot(312); hist(dTi, 25); title( 'HIST(blad) dla Interp 1' );
subplot(313); hist(dTa, 25); title( 'HIST(blad) dla Interp 3' ); xlabel('blad'); pause