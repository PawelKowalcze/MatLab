% Lab3.1: Metoda Gaussa-Jordana

R0=0.1;   R1=5;     R2=1;    R3=8;
E1=12.1;  E2=11.9;  E3=12.6;

A = [ R1+R2 ,  -R2  ,   0    ; ...
       -R2  , R2+R3 ,  -R3   ; ...
       0    ,  -R3  ,  R3+R0 ];
b = [ E1-E2; ...
      E2-E3; ...
      E3 ];

% TEST
% A = [ 1, 1, 1; 2, 3, 5; 4, 6, 8];     b = A * [ 1; 2; 3];   % A is not diagonally dominant 
A = [ 10, 2, 3; 4, 50, 6; 7, 8, 90];  b = A * [ 1; 2; 3];   % A is diagonally dominant 

disp('det(A) = '); det(A)

disp('   INV     GaussJordan    Gauss    LU       ITER');
%x1      = inv(A)*b;
x1       = A\b;
x2       = fGaussJordan(A, b);
x3       = fGauss(A, b);
[x4,L,U] = fLU(A,b);
x5       = fITER(A,b);

[ x1, x2, x3, x4, x5 ], pause

disp('Moje LU')
L,U,
disp('Matlab LU')
[L,U]=lu(A),
pause
   