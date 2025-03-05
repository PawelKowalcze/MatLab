% optim_surf.m
clear all; close all;

f = @(x,y) x.*exp(-x.^2-y.^2)+(x.^2+y.^2)/20;
figure; fsurf(f,[-2,2],'ShowContours','on'); xlabel('x'); ylabel('y'); title('z=f(x,y)');