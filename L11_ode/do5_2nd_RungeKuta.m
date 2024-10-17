% Metoda Runge-Kutty 7 dla układu inercyjnego 2-ego rzędu - odpowiedź skokowa
% uklad RLC
clear all; close all;

if(1)                           % Zadane {R,L,C}
   R = 100; L = 1e-2; C = 1e-6;
   A = [       0,    1  ;
        -1/(L*C), -R/L ];
   B = [      0   ;
         1/(L*C) ];
   w0  = 1/sqrt(L*C),
   ksi = (R/(2*L))/w0,
   w1  = w0*sqrt(1-ksi^2), pause
else                            % Zadane { w0, ksi }   
  w0 = 1e+4; ksi = 0.5;
  A = [   0,         1;
      -w0^2, -2*ksi*w0];
  B = [   0;
        w0^2];
end

% Całkowanie równań stanu - metoda Runge-Kuta 4
dt = 1e-6;            % krok całkowania
tv = 0 : dt : 1e-3;   % chwile całkowania
u = 1;                % pobudzenie
x  = [0; 0];          % stan początkowy
xv = [];              % obliczany wynik całkowania
for t = tv
   xv = [xv, x];
   D1 = dt*( A*x        + B*u );
   D2 = dt*( A*(x+D1/2) + B*u );
   D3 = dt*( A*(x+D2/2) + B*u );
   D4 = dt*( A*(x+D3)   + B*u );
   x = x + ( D1 + 2*D2 + 2*D3 + D4 )/6;
end

% Porównanie z odp. teoretyczną
ref = inline('(1-1/sqrt(1-ksi^2)*exp(-ksi*w0*t).*sin(w0*sqrt(1-ksi^2)*t+asin(sqrt(1-ksi^2))))','t','ksi','w0');
plot(tv, xv(1,:),'r', tv, ref(tv,ksi,w0), 'g--'); grid; title('y(t)'); pause
