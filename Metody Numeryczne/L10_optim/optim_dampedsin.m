% optim_dampedsin.m
% szukanie wartosci parametrow tlumionej sinusoidy

N=100; x=0:N-1; A=1; d=0.01; omega=pi/10;
y = A*exp(-d*x).*sin(omega*x) + 0.025*randn(1,N);
plot(x,y);

% znajdz: A, d, omega ... na podstawie zbioru par punktow (x,y)
