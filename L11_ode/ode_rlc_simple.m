% RLC
clear all; close all;

% L*I'' + R*I' + (1/C)*I = E'(t)
% L*Q'' + R*Q' + (1/C)*Q = E(t)
% Q'' = 1/L*( E(t) - R*Q' - Q/C );
% fun = @(t,x) [ x(2);
%                1/L*(E - R*x(2) - x(1)/C) ];

% R*I + L*I' + Uc = E
% C*Uc' = I
% x1' = 1/L*(E - R*x2 - x1)
% x2' = 1/C*x1 


R = 10;                 % rezystor        [Ohm]
L = 100e-3;             % cewka           [Henr]
C = 50e-6;              % kondensator     [Farad]
E = 10;                 % napięcie        [Volt]
ts = 0:0.001: 0.15;     % czas symulacji  [s]
x0 = [ 0, 0 ];          % stan początkowy
fun = @(t,x) [ 1/L*(E - R*x(2) - x(1));
               1/C*x(1)                ];

[t,x] = ode45( fun, ts, x0 );
figure;
subplot(211); plot(t,x(:,1)); xlabel('czas'); ylabel('x1(t)'); grid;
subplot(212); plot(t,x(:,2)); xlabel('czas'); ylabel('x2(t)'); grid; pause

if(0) % To samo, alternatywnie
   b = [ 1/C ];
   a = [ L, R, 1/C];
else   
   b = [ 1 ];
   a = [L*C, R*C, 1 ];
end   
figure;
subplot(211); impulse(b,a);
subplot(212); step(b,a);   pause
