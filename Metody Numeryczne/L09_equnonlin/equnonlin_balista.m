% equnonlin_balista.m
clear all; close all;

m=5; v0=50; alpha=30; h=50; g=9.81;
alpha = alpha/180*pi;
 x = 0 : 1 : 350;
%x = 320 : 0.001 : 330;
y = h + tan(alpha)*x - g / (2*v0^2*cos(alpha)) * x.^2;
figure; plot(x,y); xlabel('x'); ylabel('y'); title('y(x)'); grid;