% ode_vanderpol.m
% Przyklad rozwiazania numerycznego rownania rozniczkowego van der Pola
% Patrz: https://www.mathworks.com/help/matlab/math/differential-equations.html
clear all; close all;

global mi

  %  Funkcje ODE23 and ODE45 sluza do numerycznego rozwiazywania zwyczajnych
  %  rownan rozniczkowych. Wykorzystuja one metode Rungego-Kutty-Fehlberga,
  %  w ktorej krok calkowania numerycznego jest zmieniany autowatycznie
  %  ODE23 wykorzystuje zaleznosci 2 i 3 rzedu -  srednia dokladnosc,
  %  ODE45 wykorzystuje zaleznosci 4 i 5 rzedu -  duza dokladnosc.
  %
  %  Zalozmy, ze interesuje nas rozwiazanie rownania rozniczkowego
  %  van der Pola drugiego rzedu postaci :
  %	   y'' - mi*(1-y^2)*y' + y = 0
  %  gdzie ' oznacza operator rozniczkowania.
  %  Po przedstawieniu w postaci:
  %	   y'' = mi*(1-y^2)*y' - y
  %  rownanie to mozna zastapic ukladem dwoch rownan rzedu pierwszego
  %  (po dodatkowy podstawieniu y1=y (!)), 
  %	   y1' = y2
  %	   y2' = mi*(1-y1^2)*y2 - y1
  %  gdzie y1 i y2 nazywane sa tzw. zmiennymi stanu
  %
  %  Aby zasymulowac uklad dynamiczny opisany rownaniem rozniczkowym
  %  tworzy sie *.m funkcje, ktora otrzymuje wartosci czasu i zmiennych
  %  stanu, zas zwraca pochodne wartosci zmiennych stanu
  %
  %  Zalozmy, ze nasza funkcja nazywa sie FUN_DIFF.M
  %
  %  Aby zasymulowac rownanie rozniczkowe Van Der Pola w przedziale
  %  czasu  0 < t < 20, wywolujemy funkcje MATLABA ODE23:

  mi = 1;                 % definicja stałej (GLOBALNEJ) w równaniu vab der Pola
  t0 = 0;                 % czas poczatkowy obserwacji
  tfinal = 20;            % czas koncowy obserwacji
  tspan = [ t0 tfinal ];  % razem
  y0 = [0; 0.25];         % zakladane wartosci poczatkowe zmiennych stanu [y1,y2]
  trace = 1;              % wymagane sledzenie

  options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]);   % wybór opcji
  [t,y] = ode23( 'fun_diff', tspan, y0, options, trace);  % rozwiązanie numeryczne
  figure
  subplot(211); plot(t,y(:,1)), title('y1(t) dla ODE23'), grid,       % y1(t)=y(t)
  subplot(212); plot(t,y(:,2)), title('y2(t) dla ODE23'), grid, pause % y2(t)=y'(t)
  figure;
  plot(y(:,1),y(:,2)), title('Przestrzen fazowa y2(t)=fun( y1(t) ) dla ODE23'), grid, pause
  clc
  
  % A teraz z ODE45

  [T,Y] = ode45( 'fun_diff', tspan, y0, options);

  plot(T,Y(:,1),'ro', t,y(:,1),'b*'), title('y1(t)=y(t) dla ODE23(o) i ODE45(*)'), grid
  xlabel('Krok w ODE45 jest wiekszy niz w ODE23'), pause

% A teraz "nasze" implementacje   
% Euler
  [t,y] = odeEuler('fun_diff', tspan, y0, 10*length(T) );  % 10* więcej punktów niż w ode45 
  figure; plot( T, Y(:,1),'ro-', t, y(:,1),'bx-'), title('ode45 (o) i NASZ Euler (x)');
  legend('ode45','NASZ Euler(t)'); grid; xlabel('t [s]'); pause
% Runge-Kutta 4
  [t,y] = odeRK4('fun_diff', tspan, y0, 10*length(T) );    % 10* więcej punktów niż w ode45 
  figure; plot( T, Y(:,1),'ro-', t, y(:,1),'bx-'), title('ode45 (o) i NASZ Runge-Kutta 4 (x)');
  legend('ode45','NASZ RK4'); grid; xlabel('t [s]'); pause
% Adams-Bashforth
  [t,y] = odeAB('fun_diff', tspan, y0, 10*length(T) );     % 10* więcej punktów niż w ode45 
  figure; plot( T, Y(:,1),'ro-', t, y(:,1),'bx-'), title('ode45 (o) i NASZ Adams-Bashforth (x)'), grid;
  legend('ode45','NASZ AB'); grid; xlabel('t [s]'); pause
