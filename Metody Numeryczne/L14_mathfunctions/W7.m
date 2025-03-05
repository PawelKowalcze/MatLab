% Logarytmy

clear all; close all;

x = 0 : 0.01 : 1;

y1 = log(1+x);
y2 = x.*(6+x)./(6+4*x);
y3 = x.*(6+0.7662*x)./(5.9897+3.7658*x);

figure;
plot(x,y1,'r',x,y2,'g',x,y3,'b'); grid; pause

y1 = log((1+x)./(1-x));
y2 = 2*x.*(15-4*x.^2) ./ (15-9*x.^2);

figure;
plot(x,y1,'r',x,y2,'g'); grid; pause

