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
  %	   x'' - mi*(1-x^2)*x' + y = 0
  %  gdzie ' oznacza operator rozniczkowania.
  %  Po przedstawieniu w postaci:
  %	   x'' = mi*(1-x^2)*x' - x
  %  rownanie to mozna zastapic ukladem dwoch rownan rzedu pierwszego
  %  (po dodatkowy podstawieniu x1=x (!)), 
  %	   x1' = x2
  %	   x2' = mi*(1-x1^2)*x2 - x1
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

  mi = 1;                 % definicja stalej (GLOBALNEJ) w rownaniu van der Pola
  t0 = 0;                 % czas poczatkowy obserwacji
  tfinal = 20;            % czas koncowy obserwacji
  tspan = [ t0 tfinal ];  % razem
  x0 = [0; 0.25];         % zakladane wartosci poczatkowe zmiennych stanu [x1,x2]
  trace = 1;              % wymagane sledzenie

  options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]);   % wybor opcji
  [t,x] = ode23( 'fun_diff', tspan, x0, options, trace);  % rozwiazanie numeryczne
  figure
  subplot(211); plot(t,x(:,1)), xlabel('t [s]'); title('x1(t) dla ODE23'), grid,       % x1(t)=x(t)
  subplot(212); plot(t,x(:,2)), xlabel('t [s]'); title('x2(t) dla ODE23'), grid, pause % x2(t)=x'(t)
  figure;
  plot(x(:,1),x(:,2)); xlabel('x1(t)'); ylabel('x2(t)'); 
  title('Przestrzen fazowa x2(t)=fun( x1(t) ) dla ODE23'), grid, pause
  clc
  
  % A teraz z ODE45

  [T,X] = ode45( 'fun_diff', tspan, x0, options);

  plot(T,X(:,1),'ro', t,x(:,1),'b*'), title('x1(t)=x(t) dla ODE23(o) i ODE45(*)'), grid
  xlabel('Krok w ODE45 jest wiekszy niz w ODE23'), pause

% A teraz "nasze" implementacje   
% Euler
  [t,x] = odeEuler('fun_diff', tspan, x0, 10*length(T) );  % 10* wiecej punktow niz w ode45 
  figure; plot( T, X(:,1),'ro-', t, x(:,1),'bx-'), title('ode45 (o) i NASZ Euler (x)');
  legend('ode45','NASZ Euler(t)'); grid; xlabel('t [s]'); pause
% Runge-Kutta 4
  [t,x] = odeRK4('fun_diff', tspan, x0, 10*length(T) );    % 10* wiecej punktow niz w ode45 
  figure; plot( T, X(:,1),'ro-', t, x(:,1),'bx-'), title('ode45 (o) i NASZ Runge-Kutta 4 (x)');
  legend('ode45','NASZ RK4'); grid; xlabel('t [s]'); pause
% Adams-Bashforth
  [t,x] = odeAB('fun_diff', tspan, x0, 10*length(T) );     % 10* wiecej punktow niz w ode45 
  figure; plot( T, X(:,1),'ro-', t, x(:,1),'bx-'), title('ode45 (o) i NASZ Adams-Bashforth (x)'), grid;
  legend('ode45','NASZ AB'); grid; xlabel('t [s]'); pause
