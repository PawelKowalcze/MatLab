function [t,x] = odeAB( fun, tminmax, x0, M )
% NASZA FUNKCJA
dt = (tminmax(2)-tminmax(1))/M;      % krok w czasie
t = tminmax(1) + dt*(0:M);           % punkty czasowe do calkowania
x = zeros(length(x0),M+1);           % inicjalizacja
x(1:length(x0),1) = x0;              % pierwsze podstawienie, war. poczatkowe
for k = 1 : 2                                           % INICJALIZACJA - RK4
    d1 = dt * feval( fun, t(k),      x(:,k)      );     %
    d2 = dt * feval( fun, t(k)+dt/2, x(:,k)+d1/2 );     %
    d3 = dt * feval( fun, t(k)+dt/2, x(:,k)+d2/2 );     %
    d4 = dt * feval( fun, t(k)+dt,   x(:,k)+d3   );     %
    x(:,k+1) = x(:,k) + (d1 + 2*d2 + 2*d3 + d4) / 6;    % nowa wartosc calki
end
for k = 3 : M                                              % PETLA - obliczanie calki
    fk   = feval( fun, t(k  ), x(:,k  ) );                 %
    fkm1 = feval( fun, t(k-1), x(:,k-1) );                 %
    fkm2 = feval( fun, t(k-2), x(:,k-2) );                 %
    x(:,k+1) = x(:,k) + dt/12*( 23*fk - 16*fkm1 + 5*fkm2); % nowa wartosc calki
end
t=t'; x=x.';
