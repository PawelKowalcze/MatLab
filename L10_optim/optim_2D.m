% optim_2D.m
% Minimum funkcji dwuwymiarowej: szukamy jego polozenia x=(x1,x2) i wartosci fval=f(x1,x2)
clear all; close all;

f = @(x) 2+x(1)-x(2)+2*x(1)^2+2*x(1)*x(2)+x(2)^2;    % rownanie funkcji 2D: z=f(x1,x2)
[x,fval] = fminsearch(f,[-0.5,0.5])                  % szukanie jej minimum

figure                                               % RYSUNEK
x1 = linspace(-2.0, 0, 41); x2=linspace(0, 3, 61);   % siatka: od-do-ile punktow
[X1,X2] = meshgrid(x1,x2);                           % wszystkie punkty (x1,x2)
Z = 2+X1-X2 + 2*X1.^2 + 2*X1.*X2 + X2.^2;            % wartosci w punktach siatki
zmin = min(min(Z)),                                  % wartosc minimalna na siatce
subplot(1,2,1);
cs = contour(X1,X2,Z); clabel(cs); xlabel('x_1'); ylabel('x_2'); title('Contour'); grid;
subplot(1,2,2);
cs = surfc(X1,X2,Z); xlabel('x_1'); ylabel('x_2'); zlabel('f(x_1,x_2)'); title('Mesh');
