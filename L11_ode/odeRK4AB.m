function [t,x] = odeRK4AB( A, B, u, tv, x0 )
% NASZA FUNKCJA
dt = tv(2)-tv(1);                         % punkty równoodległe
K = length(x0); M = length( tv );         % liczba zmiennych, liczba punktów           
xv = zeros( K, M );                       % inicjalizacja
x = x0; xv( 1:K, 1 ) = x0;                % pierwsze podstawienie, war. poczatkowe
for k = 1 : M-1                           % # PETLA
    D1 = dt*( A*x        + B*u(k) );      % #
    D2 = dt*( A*(x+D1/2) + B*u(k) );      % #
    D3 = dt*( A*(x+D2/2) + B*u(k) );      % #
    D4 = dt*( A*(x+D3)   + B*u(k) );      % #
    x = x + ( D1 + 2*D2 + 2*D3 + D4 )/6;  % # nowa wartość całki oznaczonej
    xv(1:K,k+1) = x;                      % # zapamietaj
end
t=tv'; x=xv.';
