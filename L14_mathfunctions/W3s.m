
% Sinusoida rekursywnie - "sygnałowo"
clear all; close all;

f0 = 1; phi = pi/4; % pi/4;

fpr = 20;
w0 = 2*pi*f0/fpr;

N = 100;
n = 0:N-1;
y1 = sin( w0*n + phi );

y(1) = sin( phi - 2*w0 );
y(2) = sin( phi -   w0 );
a = 2*cos(w0);
for n = 3 : N+2
    y(n) = a*y(n-1) - y(n-2);
end
y2 = y(3:end); y = [];
n = 0:N-1;
figure; plot(n,y1,'ro-',n,y2,'go-'); grid; title('y=f(n)')
legend('Sinus','Rekursywnie');
pause

u(1) = cos( w0/2 );
v(1) = 0;
b = 2*sin( w0/2 );
for n = 2 : N
    u(n) = u(n-1) - b*v(n-1);
    v(n) = v(n-1) + b*u(n);
end
y3a = u(1:end); y3b = v(1:end);
n = 0:N-1; y1 = sin( w0*n );
figure; plot(n,y1,'r',n,y3a,'go-',n,y3b,'bo-'); grid; title('y=f(n)')
legend('Sinus','Magic u','Magic v');
pause


