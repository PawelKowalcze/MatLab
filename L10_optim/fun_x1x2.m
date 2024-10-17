function [f,fp]=fxy(x)
f  = (x(1)-1).^2 + 100*x(2).^2;
fp = [ 2*(x(1)-1); 200*x(2) ];