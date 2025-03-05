% Lab7.0 Wartoœci w³asne - wstêp

clear all; close all;

disp('111111111111111111111111111111111111111111111')
A = rand(3,3);
[V,D] = eig(A),
error1 = A - V*D*inv(V)

disp('222222222222222222222222222222222222222222222')
A = [ 1 2 3 ; ...
      2 1 4 ; ...
      3 4 2 ];
[V,D] = eig(A),
error2 = A - V*D*V.'

disp('333333333333333333333333333333333333333333333')
% A*x = b --> (A-lambda*I)*v = 0
lambda = roots(poly(A)),
