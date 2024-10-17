% Układ RLC
clc; clear; close all;

global R L C E f0

  R = 2;             % rezystor          [ Ohm ]
  L = 5*10^(-6);     % cewka indukcyjna  [ H ]
  C = 1*10^(-6);     % kondensator       [ F ]
  E = 1; f0 = 1e+6;  % parametry pobudzenia: napięcie [V], częstotliwość [Hz]

  if(0)              % ZAPIS #1
    b = [1/C];       % od najwyższego rzędu: b0
    a = [L R 1/C];   % od najwyższego rzędu: a2*s^2+a1*s+a0
  else               % ZAPIS #2  
    b = [1];         % od najwyższego rzędu: b0
    a = [L*C R*C 1]; % od najwyższego rzędu: a2*s^2+a1*s+a0
  end

  ksi = (R/(2*L))*(sqrt(L*C))                 % stała tłumienia
  f0  = (1/sqrt(L*C))/(2*pi), w0 = 2*pi*f0;   % częstotliwość/pulsacja drgań nietłumionych
  f1  = (f0*sqrt(1-ksi^2)),   w1 = 2*pi*f1;   % częstotliwość/pulsacja drgań tłumionych

% Ch-ka czestotliwościowa - wartosc ilorazu dwoch wielomianow transmitancji
  f  = 0 : 1e+3 : 1e+6;                       % zakres częstotliwości
  s = j*2*pi*f;                               % zmienna "s" transformacji Laplace'a
% Metoda #1
  bb = b(end:-1:1);
  aa = a(end:-1:1);
  for k = 1 : 1 : length(f)
     nom = 0;
     for i = 1 : 1 : length(b) 
         nom = nom + bb(i)*s(k)^(i-1);
     end
     denom = 0;
     for i = 1 : 1 : length(a) 
         denom = denom + aa(i)*s(k)^(i-1);
     end
     H1(k) = nom / denom;
  end
% Metoda #2
  H2 = polyval(b,s)./polyval(a,s);
% Metoda #3
  H3 = freqs(b,a,2*pi*f);

  err1 = max(abs(H1-H3)), 
  err2 = max(abs(H2-H3)), pause
  H = H3;

  figure(1);
  semilogx(f,20*log10(abs(H))); xlabel('f [Hz]'); title('|H(f)| [dB]'); grid on; pause
  figure(2);
  semilogx(f,unwrap(angle(H))); xlabel('f [Hz]'); title('faza(H(f)) [rad]'); grid on; pause

% Sumulacja: funkcje impulse(), step(), lsim()
  dt = 10^(-5)/1000; t = 0 : dt : 2.5*10^(-5);     % krok w czasie, czas
  u = E*ones(1,length(t));                         % # dowolne pobudzenie
% u = E*sin(2^pi*f0*t);                            % # 
  figure(3);  impulse( b, a );   grid; pause       % odpowiedz impulsowa
  figure(4);  step( b, a );      grid; pause       % odpowiedz skokowa
  figure(5);  lsim( b, a, u, t); grid; pause       % odpowiedz na dowolne pobudzenie

% ODE Runge-Kutta 45 - funkcja Matlaba
  tspan = [ t(1) t(end) ];   % czas symulacji: od-do
  y0 = [ 0; 0 ];             % warunki początkowe: [uC(t(1)), i(t(1))] 
  fun = @(t,y) ( [ 1/C*y(2); ...                                 % pobudzenie:
                   1/L * (E                - R*y(2) - y(1)) ] ); % skok jednostkowy
%                  1/L * (E*sin(2*pi*f0*t) - R*y(2) - y(1)) ] ); % sinus            
  [T,Y] = ode45( fun, tspan, y0 );
% [T,Y] = ode45( 'fun_rlc', tspan, y0 );
  figure; plot( T, Y(:,1),'r.-', T, Y(:,2),'b.-'), title('ODE45: uC(t) i i(t)');
  legend('uC(t)','i(t)'); grid; xlabel('t [s]'), pause

% NASZA FUNKCJA ODE Runge-Kutta 4 z macierzami A, B dla równania liniowego
  A = [   0,  1/C  ;               % A i B - macierze równań stanu
       -1/L, -R/L ];               %
  B = [  0   ;                     %
        1/L ];                     %
  x0 = [ 0; 0];                    % warunki początkowe: [uC(1), i(1)]
  u = E*ones(1, length(t));        % pobudzenie #1: skok jednostkowy
% u = E*sin(2*pi*f0*t);            % pobudzenie #2: sinusoidalne
  dt = 10^(-5)/1000; t = 0 : dt : 2.5*10^(-5);      % krok w czasie, czas
  [t,y] = odeRK4AB( A, B, u, t, [0; 0]);
  figure; plot( t, y(:,1),'r.-', t, y(:,2),'b.-'), title('odeRK4A: uC(t) i i(t)');
  legend('uC(t)','i(t)'); grid; xlabel('t [s]'), pause

% Porownanie z funkcją Matlaba ode45
  figure; plot( T, Y(:,1),'ro-', t, y(:,1),'bx-'), title('uC(t): ode45 (o) i odeRK4AB');
  legend('Matlab','MY)'); grid; xlabel('t [s]'), pause

% Porownanie z teoretyczna odpowiedzia na skok jednostkowy
  ref = inline('(1-1/sqrt(1-ksi^2)*exp(-ksi*w0*t).*sin(w0*sqrt(1-ksi^2)*t+asin(sqrt(1-ksi^2))))','t','ksi','w0');
  figure; plot(t, y(:,1),'bx--', t, ref(t,ksi,w0), 'ro--'); grid;
  title('uC(t): REF (o) NASZE (x)'); xlabel('t [s]'), legend('REF','NASZE'); 
  pause
