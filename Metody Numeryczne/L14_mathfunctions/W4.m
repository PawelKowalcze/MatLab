% Rotacja zespolona
% Sinusoida o częstotliwości f0 spróbkowana z częstotliwością fpr
% czyli x(n) = sin( 2*pi*f0/fpr * n ), n = 0,1,2,3,... 
% np. f0=1000 Hz, fpr=44100 Hz (płyta CD z muzyką) 
clear all; close all;

% Parametry
dx = 2*pi*1000/44100; %  dx = phi = 2*pi*f0/fpr = 2*pi / (fpr/f0)
N = 100;

% Odniesienie
n = 0:N-1;
y1 = exp( j*n*dx );

% Sekwencja rotacji
y2re(1) = cos(dx*0);
y2im(1) = sin(dx*0);
R = [ cos(dx) -sin(dx); ...
      sin(dx)  cos(dx) ];
for n = 2 : N
    rot = R * [ y2re(n-1); y2im(n-1) ];
    y2re(n) = rot(1,1);
    y2im(n) = rot(2,1);
end 

figure;
n = 0:N-1;
subplot(211); plot(n,real(y1),'r-',n,y2re,'b-'); grid; title('cos()');
subplot(212); plot(n,imag(y1),'r-',n,y2im,'b-'); grid; title('sin()'); pause
