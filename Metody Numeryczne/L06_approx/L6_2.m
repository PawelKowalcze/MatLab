
% Lab 6.2 Estymacja odpowiedzi impulsowej kana³u transmisyjnego

clear all; close all;

h = [3 -2 1 ];  h=h';  L = length(h);
figure; stem(h,'filled'); title('h(n)'); grid; pause

 prbs=[-1,-1,-1,-1,1,-1,1,-1,1,1,1,-1,1,1,-1,1,-1,1,-1,-1,1]';
%prbs=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]';
x = [ prbs ];  % ; prbs; prbs ];
N = length(x);

r = x(L:-1:1);
c = x(L:N);
X = toeplitz(c,r), pause

y = X*h;
%y = awgn(y,0);
%he = pinv(X)*y;  % inv(X'*X) * X'*y = Rxx * rxy
he = X \ y;
plot(1:L,h,'ro',1:L,he,'bx'); title('Obliczone h(n)'); grid; pause
