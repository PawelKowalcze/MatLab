% rowlin_obwod_dc.m
clear all; close all;

Ze= 2; Zs1= 2; Zs2 = 3; Zd = 4; Zo = 5; 
E = 3;

A = [  1/Ze + 1/Zs1 , -1/Zs1  ,     0;  ...
         -1/Zs1, 1/Zs1 + 1/Zs2+1/Zd,   -1/Zs2;  ...
           0,   -1/Zs2, 1/Zs2 + 1/Zo   ],
b = [ E/Ze; ...
      0; ...
        0  ],
% x = ?

x1 = inv(A)*b;   % inv(A)  = A^(-1)
x2 = pinv(A)*b;  % pinv(A) = (A^T * A)^(-1) * A^T
x3 = A \ b;      % minimaliacja bledu sredniokwadratowego

% Metoda Cramera
for k=1:length(b)
    Ak = A; Ak(:,k) = b; % (w,k) = (:,k)
    x4(k) = det( Ak ) / det(A); 
end    
x4 = x4.';
[ x1, x2, x3, x4 ], pause