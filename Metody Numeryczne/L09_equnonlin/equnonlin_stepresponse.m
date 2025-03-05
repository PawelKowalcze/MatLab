% equnonlin_stepresponse.m
clear all; close all;

iter = 12; a=2; b=4;   % liczba iteracji, wartosci poczatkowe argumentu funkcji
figure; t=0:0.01:10; plot([t(1),t(end)],[0,0],'r--',t,f(t),'b-');
title('x(t)'); xlabel('t [s]'); grid; pause
cb = nlsolvers('bisection',a,b,iter);
cr = nlsolvers('regula-falsi',a,b,iter);
cn = nlsolvers('newton-raphson',a,b,iter);
figure; plot( 1:iter, cb, 'o-', 1:iter, cr,'*-', 1:iter, cn, '^-');
title('c(k) \approx t_0(k) [s]'); xlabel('k'); ylabel('[s]');
grid on, legend('Bisection','Regula-Falsi','Newton-Raphson');

% ###############
function y = f(t)
% odpowiedz skokowa obiektu oscylacyjnego minus 1
w0=1; ksi=0.5;
p1 = sqrt(1-ksi^2);
y = -1/p1 * exp(-ksi*w0*t);
y = y .* sin(w0*p1*t+asin(p1));
end

% ##############
function y=fp(t)
% pochodna odpowiedzi skokowej, czyli odpowiedz impulsowa
w0=1; ksi=0.5;
p1 = sqrt(1-ksi^2);
y = w0/p1 * exp(-ksi*w0*t);
y = y .* sin(w0*p1*t);
end

% ##########################################
function C = nlsolvers( solver, a, b, iter )
C=zeros(1,iter); c=a;
for i=1:iter
  switch(solver)
  case 'bisection',
      if f(a)*f(c)<0 b=c; else a=c; end
      c=(a+b)/2;
  case 'regula-falsi',
      if f(a)*f(c)<0 b=c; else a=c; end
      c=b-f(b)*(b-a)/(f(b)-f(a));
  case 'newton-raphson',
      c=c-f(c)/fp(c);
  otherwise,
      error('Brak metody');
  end
  C(i)=c;
end
end
