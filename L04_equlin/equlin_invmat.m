% equlin_invmat.m
% A*x = b, x=?
clear all; close all;

A = [  1 2; ...
       3 4  ];
 
b = [    5; ...
        11  ];

x1 = inv(A)*b,          % x=A^(-1)*b
x2 = A\b,               % optymalne rozwiazywanie rown. Ax=b
%x3 = pinv(A)*b,        % x = inv( A'*A ) * A' * b , sprawdzisz?

bhat = A*x1,            % sprawdzenie
err = max(abs(x1-x2)),  % blad
