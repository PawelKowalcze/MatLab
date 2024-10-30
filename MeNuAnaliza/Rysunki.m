x = 0 : pi/100 : 2*pi; % argument funkcji: wiele wartosci od-krok-do
y = sin( x ); % funkcja: wiele wartosci
figure;
%plot(x,y, 'b- ');
%semilogx(x,y); potęgi 10 na osi X
%semilogy(x,y); potęgi 10 na osi Y
%loglog(x,y); potęgi 10 na osi X i Y

xlabel( 'x ');
ylabel( 'y ');
title( 'F1: y=f(x) ');
grid;



x = -3*pi : pi/10 : 3*pi; % argument
y1 = exp( -0.1*x.^2 ); % gaussoida
y2 = y1 .* cos( x ); % gaussoida razy kosinusoida
figure; plot(x,y1, 'bo- ',x,y2, 'r*- '); grid; xlabel( 'x '); ylabel( 'y ');
legend( 'y1(x) ', 'y2(x) '); title( 'F1: y1=f1(x), y2=f2(x) ');
y = x';
X = repmat( x, length(x), 1);
Y = repmat( y, 1, length(x));
Z = exp( -0.1*(X.^2 + Y.^2) ) .* cos( sqrt(X.^2+Y.^2) );
figure; plot3(X,Y,Z); xlabel( 'x '); ylabel( 'y '); zlabel( 'z '); title( 'plot3 (x,y,z) ');
figure; mesh(X,Y,Z); xlabel( 'x '); ylabel( 'y '); zlabel( 'z '); title( 'mesh z=f(x,y) ');
figure; contour(X,Y,Z); xlabel( 'x '); ylabel( 'y '); zlabel( 'z '); title( 'contour z=f(x,y) ');
figure; imagesc(x,y,Z); xlabel( 'x '); ylabel( 'y '); zlabel( 'z '); title( 'imagesc z=f(x,y) ');
figure; % (liczba wierszy, liczba kolumn, numer rysunku - poziomo).
subplot(121); plot(x,y1, 'bo- ',x,y2, 'r*- '); % (121) - rys. lewy
subplot(122); mesh(X,Y,Z); % (122) - rys. prawy