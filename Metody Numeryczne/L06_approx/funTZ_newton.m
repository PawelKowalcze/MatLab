function [yi,p,a] = funTZ_newton(xk,yk,xi)

Nk=length(xk);
Ni=length(xi);

% Divided diffrences
D(:,1)=yk(1:Nk);
for c=2:Nk
    for r=c:Nk  % only down; below D(): col before, diff of last two elements
        D(r,c) = (D(r,c-1)-D(r-1,c-1)) / (xk(r)-xk(r-c+1));
    end
end
a = diag(D);

% Interpolated values
yi=[];
for i=1:Ni
    yi(i) = cumprod( [1, xi(i)-xk(1:Nk-1)] ) * a;
end

% Coeffs of interpolating poly
p=zeros(1,Nk); p(Nk)=a(1);
for k=1:Nk-1
    p = p + a(k+1) * [ zeros(1,Nk-k-1) poly(xk(1:k)) ]; 
end
