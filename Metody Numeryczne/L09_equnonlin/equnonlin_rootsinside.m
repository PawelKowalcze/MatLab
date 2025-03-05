function r = roots(c)
% Copyright 1984-2002 The MathWorks, Inc.
...
% Polynomial roots via a companion matrix
n = length(c);
if n > 1
   a = diag(ones(1,n-2),-1);  % przesuniecie w lewo o -1
   a(1,:) = -c(2:n) ./ c(1);
   r = [r; eig(a)];
end