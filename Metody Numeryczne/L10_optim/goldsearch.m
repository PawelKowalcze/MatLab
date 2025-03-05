function [x,fx,errest,iter] = goldsearch(f,xdown,xup,err,maxiter,ifigs,xx)
% goldtz: minimization golden section search
%   f = name of function
%   xdown, xup = lower and upper guesses
%   err = desired relative error (default = 0.0001%)
%   maxit = maximum allowable iterations (default = 50)
%   x = location of minimum
%   fx = minimum function value
%   errest = approximate relative error (%)
%   iter = number of iterations
if nargin<3,error('at least 3 input arguments required'),end
if nargin<4|isempty(err), err=0.00001; end
if nargin<5|isempty(maxiter), maxiter=50;  end

phi=(1+sqrt(5))/2;
iter=0;
while(1)
  d = (phi-1)*(xup - xdown);
  x1 = xdown + d;
  x2 = xup   - d;
  
  if(ifigs==1)
    fd = feval(f,xdown);
    fu = feval(f,xup);
    f1 = feval(f,x1);
    f2 = feval(f,x2);
    plot(xx,feval(f,xx),'b-',xdown,fd,'bo',xup,fu,'ro',x1,f1,'b*',x2,f2,'r*'); grid; pause(0.25)
  end
  
  if feval(f,x1) < feval(f,x2)
    xmin = x1;
    xdown = x2;
  else
    xmin = x2;
    xup = x1;
  end
  
  iter=iter+1;
  if xmin~=0, errest = (2 - phi) * abs((xup - xdown) / xmin) * 100; end
  if errest <= err | iter >= maxiter, break, end
end
x=xmin; fx=feval(f,xmin);
