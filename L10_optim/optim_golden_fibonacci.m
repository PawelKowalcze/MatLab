
% optim_golden_fibonacci.m
clear all; close all;

% Bungee
z0 = 100; m = 80; c = 15; v0 = 55; g = 9.81;
f = @(t) -( z0 + m/c*(v0+(m*g)/c)*(1-exp(-(c/m)*t))-((m*g)/c)*t );
t0 = (m/c)*log(1+(c*v0)/(m*g)),

% Golden search
a=1; b=7;
k = 2/(1+sqrt(5));  % = (sqrt(5)-1)/2;
xL = b-k*(b-a);
xR = a+k*(b-a);
iter = 0;
while( (b-a)>1e-6 )
    if( f(xL)<f(xR) )
        b = xR; xR = xL; xL = b-k*(b-a);
    else
        a = xL; xL = xR; xR = a+k*(b-a);
    end
    iter = iter + 1;
end
disp('GOLDEN'); iter, xopt = (a+b)/2

% Fibonacci search
a=1; b=7;
tol = 10^(-5);
F = [ 1, 1 ]; n=2;
while( F(n) <= (b-a)/tol )
    n = n+1;
    F(n) = F(n-1)+F(n-2);
end
(b-a)/tol, F(n),
imax = n, pause

k = F(imax-1)/F(imax); % pause
xL = b - k*(b-a);
xR = a + k*(b-a);
i = imax-1;
iter = 1;
while( i > 1 )
    k = F(i-1)/F(i);
    if( f(xL)<f(xR) )
        b = xR; xR = xL; xL = b-k*(b-a);  
    else
        a = xL; xL = xR; xR = a+k*(b-a); 
    end
    i = i - 1;
    iter = iter + 1;
end
disp('FIBONACCI'); t0, iter, xopt = (a+b)/2
