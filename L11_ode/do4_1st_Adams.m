% Metoda Adamsa-Bashfortha dla układu inercyjnego 1-szego rzędu
% np. układ całkujący RC
clear all; close all;

if( 1 )
    R = 1e+5;  % rezystor [ Ohm ]
    C = 1e-6;  % kondensator [ F ]
    T = R*C;
else
  T = 0.1;
end    

% Odniesienie
dt = 0.001; tv = 0:dt:1;
ref = inline('(1-exp(-t/T))','t','T');

% Całkowanie równań stanu
A = -1/T; B = 1/T;
x = 0; u = 1;
xv = ref( tv(1:3), T);
for k = 3:length(tv)
    x = xv(k);
    F0 = A*xv(k)   + B*u;
    F1 = A*xv(k-1) + B*u;
    F2 = A*xv(k-2) + B*u;
    x = x + dt*( 23*F0 -16*F1 + 5*F2 )/12;
    xv = [xv, x];
end

% Porównanie z odp. teoretyczną
plot( tv, xv(1:end-1),'r', tv, ref(tv,T),'g--'); grid; title('y(t)')
