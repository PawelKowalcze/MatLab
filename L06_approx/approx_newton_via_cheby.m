% approx_newton_via_cheby.m
% Interpolacja Newtona w wezlach Czebyszewa
clear all; close all;

N = 10;               % stopien wielomianu interpolujacego
a = -3; b = 3;        % argument funkcji myfun() od-do
xi = a : 0.01 : b;    % dokladne, rownomierne sprobkowanie argumentu funkcji
yref = myfun( xi );   % wartosci funkcji sprobkowanej gesto                   

% Probkowanie rzadkie w wezlach Czebyszewa, potem interpolacja
k = 0:N;                            % numery kolejnych N+1 punktow
theta = ((2*N+1)-2*k)*pi/(2*N+2);   % katy Czebyszewa
xk = cos( theta );                  % kolejne argumenty w przedz. [-1,1]
xk = (b-a)/2*xk + (a+b)/2;          % przeskalowane do [a,b]
yk = myfun( xk );                   % funkcja spobkowana w wezlach Czebyszewa
[yi,p,an] = funTZ_newton(xk,yk,xi); % interpolacja w wezlach Czebyszewa
%yi = polyval(p,xi);                % alternatywa jesli juz znamy wielomian p

% Probkowanie rzadkie w wezlach rownomiernych, potem interpolacja
xkk = a : (b-a)/N : b;                   % probkowanie rownomierne
ykk = myfun( xkk );                      % funkcja spobkowana w wezlach rownomiernych
[yii,p,ann] = funTZ_newton(xkk,ykk,xi);  % interpolacja w wezlach rownomiernych

figure; plot(xi,yref,'r-',xi,yi,'b-',xk,yk,'bo',xi,yii,'b-.',xkk,ykk,'bs');
xlabel('x'); title('y=f(x)'); grid; pause 
