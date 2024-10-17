% interp_spline.m
clear all; close all;

% Funkcja dokladnie - malymi kroczkami 
x = ( -5 : 0.01 : 5)';
y = 1 ./ (1+x.^2);

% Wezly - zgrubnie - duze kroki 
xk = ( -5 : 1 : 5)';
yk = 1./(1+xk.^2);

% Linear spline
yi = interp1(xk,yk,x,'linear');
figure; plot(x,y,'r',xk,yk,'ko',x,yi,'b.'); xlabel('x'); title('y(x)'); grid; pause

% Cubic spline
yi = interp1(xk,yk,x,'cubic');
figure; plot(x,y,'r',xk,yk,'ko',x,yi,'b.'); xlabel('x'); title('y(x)'); grid; pause

% Cubic spline z Spline Toolbox 
cs = spline(x,[0; y; 0]);
yi = ppval(cs,x);
figure; plot(x,y,'r-', xk,yk,'ko', x,yi,'b.-'); xlabel('x'); title('y=f(x)'); grid; pause
