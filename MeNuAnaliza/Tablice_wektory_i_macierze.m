%horizontal vector
h = [1,3,4],

%vertical vector
v = [4;4;1],

%matrix
H1 = [h;h;h],
H2 = [h,h,h],

M = [1,2,3;4,5,6;7,8,9],

%calculations on matrixes

h*v,
v*h,

%--------------------------------------

h = [1,2,3],
v = [4;5;6],  
a=h*v,  
A=v*h,  
a=A*v,
b=h*A,  
B=A*A,

% h*h, wymiary nie są zgodne
% v*v, wymiary nie są zgodne
%v*A,
%A*h, żadne wymiary się nie zgadzają - matlab sie denerwuje

length(h),
length(v),
size(A),

h.',

h.^2,

sum(h),
sum(A), % suma elementów w kolumnach

prod(A), % iloczyn elementów w kolumnach
diag(A), % diagonala
det(A), % wyznacznik
poly(A), % wielomian charakterystyczny
inv(A), % odwrotność macierzy

C = rand(7,7),