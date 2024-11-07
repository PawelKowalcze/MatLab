clear all; close all;
% Funkcja dokladnie - malymi kroczkami
x = ( -5 : 0.01 : 5)';

% ZMIENIAMY TUTAJ - robimy różne interp_func - absolutnie dowolne, na co
% nam wyobraźnia pozwala
interp_func = @(x)(1 ./ (1 + x.^2 ));
interp_func = @(x)(sin(x.^2) + cos(3.*x));
y = interp_func(x);

% ZMIENIAMY TUTAJ, im gęstszy xk, tym bardziej będzie się pokrywała
% interpolacja z oryginalną funkcją
% Wezly - zgrubnie - duze kroki
xk = ( -5 : 1 : 5)';
yk = interp_func(xk);
hold on;
% Linear spline
yi = interp1(xk,yk,x,'linear');
plot(x,y,'r',xk,yk,'ko',x,yi,'r.');
% Cubic spline
yi = interp1(xk,yk,x,'cubic');
plot(x,y,'r',xk,yk,'ko',x,yi,'g.');
% Cubic spline ze Spline Toolbox
cs = spline(x,[0; y; 0]);
yi = ppval(cs,x);
plot(x,y,'r-', xk,yk,'ko', x,yi,'b.-');
xlabel('x'); title('y=f(x)'); grid;