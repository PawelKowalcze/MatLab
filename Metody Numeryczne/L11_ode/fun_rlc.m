function yprime = fun_rlc(t,y)
global R L C E f0
yprime = [ 1/C*y(2); ...
           1/L * (E                - R*y(2) - y(1)) ];
%          1/L * (E*sin(2*pi*f0*t) - R*y(2) - y(1)) ];