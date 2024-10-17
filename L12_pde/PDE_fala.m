% PDE_fala.m - jednokierunkowa propagacja fali elektromagnetycznej
clear all; close all;

c = 3e8;               % prędkość światła w próżni [m/s]
f = 900e6;             % częstotliwość fali RF (radio-frequency) [Hz]
w = 2*pi*f;            % pulsacja
nx = 500;              % liczba punktów w przestrzeni
nt = 400;              % liczba punktów w czasie
dtdx = 0.2;            % rozdzielczość czasowo-częstotliwościowa   
len = c/f;             % długość rozchodzącej się fali RF
k = 2*pi/len;          % wsp. skalujący x --> przesunięcie kątowe: fi = k*x
xx = 3*len;            % zakładana długość obserwacji przestrzennej
dx = xx/nx;            % liczba punktów w przestrzeni
dt = dtdx*dx/c;        % patrz tekst
q = (c*dt/dx)^2;       % patrz tekst
x = 0 : dx : xx;       % punkty przestrzenne
t = 0;                 % czas t0
u0 = sin(w*t-k*x);     % natężenie pola elektrycznego w t0
v0 = w*cos(w*t-k*x);   % natężenie pola magnetycznego w t0 (pochodna elektrycznego) 
t = dt;                % następna chwila
u1 = u0 + dt*v0;       % u(k=1) = u(k=0) + dt*du(t)/dt | dla (k=0) 
U = [u0; u1];          % zapamiętanie
tt = [ 0; dt ];        % zapamiętanie
% Iteracyjne rozwiązanie równania różniczkowego
for n = 1 : nt                 % PO CZASIE   
    t = t+dt; tt=[tt;t];       % następna chwila
    u = sin(w*t-k*x);          % nowe pobudzenie na wejściu
    for j = 2 : nx             % u2() - następna chwila w każdym pkt       % PO PRZESTRZENI
          u2(j) = q*( u1(j+1) - 2*u1(j) + u1(j-1) )  +  2*u1(j)  -  u0(j); % punkty 2 : nx
    end % (nowe)           ( druga pochodna )        2*(obecne)   (stare)  %
    u2(1) = q*( u1(2) - 2*u1(1) + u(nx) )  +  2*u1(1)  -  u0(1);           % punkt (1)
    u2(nx+1) = u2(1);                                                      % punkt (nx+1)
    U = [U; u2];       % zapamiętaj obecne rozwiązanie
    u0 = u1; u1 = u2;  % aktualizacja bufora "historii": obecne-->poprzednie-->popoprzednie 
end
plot(x,U); grid; xlabel('x [m]'); title('U(x)'); pause 

% Kino
xmin=min(x); xmax=max(x); Umin=min(min(U)); Umax=max(max(U));
px = 0.3*xmax;
py = 1.2*Umax;
figure;
for iter = 1 : size(U(:,1))
  % iter
    plot( x, U(iter,:) ), xlabel('x [m]'); title('U(x)'); grid;
    text( px, py, ['czas = ' num2str( tt(iter) ) '[sec]'] );
    axis([ xmin, xmax, Umin, 1.4*Umax ]);
    pause(0.01)
end
