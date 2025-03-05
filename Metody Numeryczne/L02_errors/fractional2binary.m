format long

a = 1234.57849; % your float point number
n = 16;         % number bits for integer part of your number      
m = 20;         % number bits for fraction part of your number
% binary number
d2b = [ fix(rem(fix(a)*pow2(-(n-1):0),2)), fix(rem( rem(a,1)*pow2(1:m),2))],  % 
% the inverse transformation
b2d = d2b*pow2([n-1:-1:0 -(1:m)].'),