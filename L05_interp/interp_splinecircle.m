% interp_splinecircle.m
clear all; close all;

% Interpolacja okregu funkcjami cubic spline
t =[  0;  1;  2;  3;  4];
x =[  1;  0; -1;  0;  1];
y =[  0;  1;  0; -1;  0];
td = 0  : 0.01 : 4;

ppx = csape( t, x, 'periodic');
ppy = csape( t, y, 'periodic');
figure; plot( ppval(ppx,td), ppval(ppy,td), 'b.-', cos(td*pi/2), sin(td*pi/2), 'r.-');
title('y=f(x)'); grid; axis square; pause
