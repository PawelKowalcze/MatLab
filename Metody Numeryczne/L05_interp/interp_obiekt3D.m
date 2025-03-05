% interp_obiekt3D.m
clear all; close all;

%load('X.mat');
 load('babia_gora.dat'); X=babia_gora;

figure; grid; plot3( X(:,1), X(:,2), X(:,3), 'b.' ); pause

x = X(:,1); y = X(:,2); z = X(:,3);            % pobranie x,y,z
xvar = min(x) : (max(x)-min(x))/200 : max(x);  % zmiennosc x
yvar = min(y) : (max(y)-min(y))/200 : max(y);  % zmiennosc y

[Xi,Yi] = meshgrid( xvar, yvar );              % siatka interpolacji xi, yi
out = griddata( x, y, z, Xi,Yi, 'cubic' );     % interp: nearest, linear, spline, cubic
figure; surf( out ); pause                     % rysunek             
figure; mesh( out ); pause                     % rysunek             
