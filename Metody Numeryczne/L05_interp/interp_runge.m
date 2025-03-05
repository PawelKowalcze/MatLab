% interp_runge.m
clear all; close all;

% Funkcja dokladnie - malymi kroczkami 
x = ( -5 : 0.01 : 5)';
y = 1 ./ (1+x.^2);

% Wezly - zgrubnie - duze kroki 
xk = ( -5 : 1 : 5)';
yk = 1./(1+xk.^2);
N  = length(xk);

% Ilorazy roznicowe w metodzie Newtona
d(:,1) = yk(1:N);
for k=2:N      % kolumny
    w = k:N;     % wiersze
    d(w,k) = ( d(w,k-1)- d(w-1,k-1) ) ./ ( xk(w)-xk(w-k+1) );
end

% Wlasciwa interpolacja
yi=[];
for i=1:length(x)
  xi =x(i);
  yi(i) = cumprod([1, (xi-xk(1:N-1))']) * diag(d);
end

% Wynik
figure; plot(x,y,xk,yk,'o',x,yi,'r');
xlabel('x'); title('y=f(x)'); grid;
