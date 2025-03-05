function yprime = fun_diff(t,y)
global mi
% funkcja zwraca pochodne zmiennych stanu y1 i y2 rownania Van der Pola,
% ktorego rozwiazanie jest wyznaczane w przykladzie ode_vanderpol.m

yprime = [                 y(2); ...
           mi*(1 - y(1).^2) .* y(2) - y(1) ];
