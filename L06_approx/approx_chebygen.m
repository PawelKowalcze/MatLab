% approx_chebygen.m
clear all; close all;

c0 = [0 1];
c1 = [1 0];

for k = 1 : 10
    cc = 2*[c1 0] - [0 c0],
    c0 = [0 c1]; c1 = cc;
end

x = -1 : 0.01 : 1;
plot(x, polyval(cc,x)); xlabel('x'); title('y=f(x)'); grid;
