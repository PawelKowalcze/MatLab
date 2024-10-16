close all;
clear all;

x = 0 : pi/100 : 2*pi; % argument funkcji: wiele wartosci od-krok-do
y = sin( x ); % funkcja: wiele wartosci
figure; plot(x,y, 'b- ');
xlabel( 'x ');
ylabel( 'y ');
title( 'F1: y=f(x) ');
grid;
save( 'myFile.mat' );