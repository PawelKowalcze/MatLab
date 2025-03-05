% diff_cps.mF
clear all; close all;

K = 5; % liczba wezlow/wag filtra
w = 0 : pi/100 : pi;
d1=1/12*[-1 8 0 -8 1],                                     % d1 = [-0.0833 0.6667 0 -0.6667 0.0833 ]
d2=firls(4,[0 0.5 0.7 1],[0 0.5*pi 0 0],'differentiator'), % d2 = [-0.0890 0.6862 0 -0.6862 0.0890 ]
d3=firpm(4,[0 0.5 0.7 1],[0 0.5*pi 0 0],'differentiator'),   d3 = [-0.0295 0.6474 0 -0.6474 0.0295 ], pause
plot( 0:0.01:0.5, 0:0.01:0.5,'k.',  ...
      w/pi, abs(freqz(d1,1,w))/pi,'b-',  ...
      w/pi, abs(freqz(d2,1,w))/pi,'r--', ...
      w/pi, abs(freqz(d3,1,w))/pi,'m-.');
xlabel('fnorm'); title('|D(fnorm)|'); grid;
legend('REF','DIFF','LS','MIN-MAX');