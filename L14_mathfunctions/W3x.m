% Sin/Cos iteracynie/rekursywnie
clear all; close all;

% Wartości parametrów
x0 = 0;       % 0, pi/4;
dx = pi/10;
N = 100;

% Odniesienie
n = 0:N-1;
x = x0 + n*dx;
y1 = sin( x );

% Metoda iteracyjna #1
y(1) = sin( x0 - 2*dx );
y(2) = sin( x0 -   dx );
a = 2*cos(dx);
for n = 3 : N+2
    y(n) = a*y(n-1) - y(n-2);
end
y2 = y(3:end);
figure; plot(x,y1,'ro-',x,y2,'go-'); grid; title('y=sin(x)')
legend('Sinus','Rekursywnie'); pause

% Metoda iteracyjna #2
u(1) = cos( dx/2 );
v(1) = 0;
b = 2*sin( dx/2 );
for n = 2 : N
    u(n) = u(n-1) - b*v(n-1);
    v(n) = v(n-1) + b*u(n);
end
y3a = u(1:end); y3b = v(1:end);
figure; plot(x,y1,'r',x,y3a,'go-',x,y3b,'bo-'); grid; title('y=sin(x)')
legend('Sinus','Magic u','Magic v'); pause
