clear all; close all;

T=0.3; t=0:0.05:1; E=-0.5:0.05:.5;
plot( t, 0.4*exp(-t/T), 'r'), hold on;

[tt,EE] = meshgrid(t,E); sc=30*sqrt( 1 + 1/T^2*EE.^2 );
quiver( tt ,EE, ones(size(tt))./sc, -1/T*EE./sc, 0);