% Sin/Cos z rozwinięcia Taylora oraz z aproksymacji Pade
clear all; close all;

x = 0 : (pi/2)/1000 : pi/2;
sref = sin( x );
cref = cos( x );

% Taylor
s = x - x.^3/prod(1:3) + x.^5/prod(1:5) - x.^7/prod(1:7);
c = 1 - x.^2/prod(1:2) + x.^4/prod(1:4) - x.^6/prod(1:6);
figure; plot(x,sref,'r',x,s,'b'); grid; pause
figure; plot(x,cref,'r',x,c,'b'); grid; pause

% Pade
s = x.*(60-7*x.^2) ./ (60+3*x.^2);
c =    (12-5*x.^2) ./ (12+x.^2);
figure; plot(x,sref,'r',x,s,'b'); grid; pause
figure; plot(x,cref,'r',x,c,'b'); grid; pause
